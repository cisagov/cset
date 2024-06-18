//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Model.Acet;
using CSETWebCore.Model.Maturity;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.ExportCSV
{
    public class CSETtoExcelNCUAMappings
    {
        private CSETContext db;
        private readonly IACETDashboardBusiness _acet;
        private readonly IACETMaturityBusiness _acetMaturity;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="db"></param>
        public CSETtoExcelNCUAMappings(CSETContext db, IACETDashboardBusiness acet, IACETMaturityBusiness acetMaturity)
        {
            this.db = db;
            _acet = acet;
            _acetMaturity = acetMaturity;
        }


        public void ProcessAssessment(int assessmentID, MemoryStream stream, string type)
        {
            DataTable dt = BuildAssessment(assessmentID, type);

            // Create an Excel document from the data that has been gathered
            var doc = new CSETtoExcelDocument();
            doc.AddDataTable(dt);
            List<DataMap> list = new List<DataMap>();
            doc.WriteExcelFile(stream, list);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="stream"></param>
        public void ProcessAllAssessmentsForUser(int userID, MemoryStream stream, string type = "")
        {
            DataTable dtAll = null;

            // get all the assessment IDs that this user has access to
            var myAssessmentIDs = db.ASSESSMENT_CONTACTS.Where(x => x.UserId == userID).Select(y => y.Assessment_Id).ToList();
            var assessmentName = "";

            foreach (int assessmentID in myAssessmentIDs)
            {
                var query = db.INFORMATION.Where(x => x.Id == assessmentID).FirstOrDefault();
                if (query != null)
                {
                    assessmentName = query.Assessment_Name;
                }

                // ignore assessments that don't have the ACET standard
                if (IsACET(assessmentID))
                {
                    continue;
                }

                // ignore the assessments the user didn't want (ACET or ISE) because they have different excel column requirements
                if (!assessmentName.Contains(type))
                {
                    continue;
                }

                // get the values as a DataTable
                DataTable dt = BuildAssessment(assessmentID, type);

                // append the row into dtAll .....
                if (dtAll == null)
                {
                    dtAll = dt.Copy();
                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        dtAll.LoadDataRow(dt.Rows[0].ItemArray, true);
                    }
                }
            }

            // Create an Excel document from the data that has been gathered
            var doc = new CSETtoExcelDocument();
            doc.AddDataTable(dtAll);
            List<DataMap> list = new List<DataMap>();
            doc.WriteExcelFile(stream, list);
        }

        public bool IsACET(int assessmentId)
        {
            return (this.db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId && x.UseMaturity).FirstOrDefault() == null);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        public DataTable BuildAssessment(int assessmentID, string type = "")
        {
            var assess = db.ASSESSMENTS
                .Include(x => x.INFORMATION)
                .Where(x => x.Assessment_Id == assessmentID)
                .FirstOrDefault();

            if (assess == null)
            {
                return null;
            }

            // A few helper classes gather data
            var acetDashboard = _acet.LoadDashboard(assessmentID);
            var maturityDomains = _acetMaturity.GetMaturityAnswers(assessmentID);

            // Build the row for the assessment
            SingleRowExport export = null;
            if (type == "ISE")
            {
                export = new SingleRowExport(type);
            }
            else
            {
                export = new SingleRowExport();
            }

            var assessName = assess.INFORMATION.Assessment_Name;

            export.d["Version"] = db.CSET_VERSION.FirstOrDefault().Cset_Version1;

            export.d["Assessment Name"] = assessName;
            export.d["CU Name"] = acetDashboard.CreditUnionName;
            export.d["CU #"] = acetDashboard.Charter;
            export.d["Assets"] = acetDashboard.Assets;

            // Build different Excel columns for ACET/ISE
            if (type == "ACET" || type == "")
            {
                ProcessIRP(assessmentID, acetDashboard, ref export, assessName);
                ProcessMaturity(acetDashboard, maturityDomains, ref export);
                ProcessStatementAnswers(assessmentID, ref export);
            }
            else if (type == "ISE")
            {
                ProcessIseIRP(assessmentID, acetDashboard, ref export, assessName);
                ProcessIseAnswers(assessmentID, ref export);
            }

            return export.ToDataTable();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="export"></param>
        private void ProcessIRP(int assessmentID, ACETDashboard acetDashboard, ref SingleRowExport export, string assessmentName)
        {
            // build a quick dictionary for textual risk level values
            Dictionary<int, string> riskLevelDescription = new Dictionary<int, string>
            {
                { 0, "0" },
                { 1, "1 - Least" },
                { 2, "2 - Minimal" },
                { 3, "3 - Moderate" },
                { 4, "4 - Significant" },
                { 5, "5 - Most" }
            };

            // gather IRPC 0 - 4 (5 is ISE specific)
            for (int i = 0; i < acetDashboard.Irps.Count - 1; i++)
            {
                export.d["IRPC" + (i + 1)] = riskLevelDescription[acetDashboard.Irps[i].RiskLevel];
            }

            var irpAnswers = db.ASSESSMENT_IRP
                .Include(x => x.IRP)
                .Where(x => x.Assessment_Id == assessmentID)
                .OrderBy(i => i.IRP.Item_Number)
                .ToList();
            // If the user never opens the Exam Profile page
            if (irpAnswers.Count == 0)
            {
                for (int i = 1; i < 40; i++)
                {
                    export.d["IRP" + i] = "0";
                }
            }
            else
            {
                foreach (var irpAnswer in irpAnswers)
                {
                    export.d["IRP" + irpAnswer.IRP.Item_Number] = irpAnswer.Response.ToString();
                }
            }
        }

        private void ProcessIseIRP(int assessmentID, ACETDashboard acetDashboard, ref SingleRowExport export, string assessmentName)
        {
            // build a quick dictionary for textual risk level values
            Dictionary<int, string> riskLevelDescription = new Dictionary<int, string>
            {
                { 0, "0" },
                { 1, "1 - Least" },
                { 2, "2 - Minimal" },
                { 3, "3 - Moderate" },
                { 4, "4 - Significant" },
                { 5, "5 - Most" }
            };

            // Currently the ISE irp's start at ID 46 and there's 9 of them, so this is a hard coded check
            // there's probably a better way to do this. Maybe add a specfic field to the db?
            var irpAnswers = db.ASSESSMENT_IRP
                .Include(x => x.IRP)
                .Where(x => x.Assessment_Id == assessmentID && x.IRP_Id > 45)
                .OrderBy(i => i.IRP.Item_Number)
                .ToList();

            // If the user never opens the Exam Profile page
            if (irpAnswers.Count == 0)
            {
                for (int i = 1; i < 10; i++)
                {
                    export.d["IRP" + i] = "0";
                }
            }
            else
            {
                foreach (var irpAnswer in irpAnswers)
                {
                    export.d["IRP" + irpAnswer.IRP.Item_Number] = irpAnswer.Response.ToString();
                }
            }


        }


        /// <summary>
        /// Get all of the maturity levels.
        /// </summary>
        /// <param name="export"></param>
        private void ProcessMaturity(ACETDashboard acetDashboard, List<MaturityDomain> maturityDomains, ref SingleRowExport export)
        {
            // gather Domain Maturity 1 - 5 (0 is ISE specific)
            for (int i = 1; i < acetDashboard.Domains.Count; i++)
            {
                export.d["Dom Mat " + i] = acetDashboard.Domains[i].Maturity;
            }

            // gather the maturity levels for all factors and components
            foreach (var m in maturityDomains)
            {
                foreach (var a in m.Assessments)
                {
                    string factorName = a.AssessmentFactor;

                    // A few factor headings have a unique suffix to avoid name conflicts in the dictionary
                    if (!export.d.ContainsKey(factorName))
                    {
                        factorName = factorName + "[FACTOR]";
                    }
                    export.d[factorName] = a.AssessmentFactorMaturity;

                    foreach (var x in a.Components)
                    {
                        string compName = x.ComponentName.Substring(x.ComponentName.IndexOf(':') + 1).Trim();

                        // A few component headings have a unique suffix to avoid name conflicts in the dictionary
                        if (!export.d.ContainsKey(compName))
                        {
                            compName = compName + "[COMPONENT]";
                        }

                        export.d[compName] = x.AssessedMaturityLevel;
                    }
                }
            }
        }


        /// <summary>
        /// Populate the answers for each of the statement columns.
        /// </summary>
        /// <param name="export"></param>
        private void ProcessStatementAnswers(int assessmentID, ref SingleRowExport export)
        {
            //var q = from s in db.SETS
            //        join rs in db.REQUIREMENT_SETS on s.Set_Name equals rs.Set_Name
            //        join req in db.NEW_REQUIREMENT on rs.Requirement_Id equals req.Requirement_Id
            //        join answ in db.ANSWER on req.Requirement_Id equals answ.Question_Or_Requirement_Id
            //        where s.Set_Name == "ACET_V1"
            //            && answ.Assessment_Id == assessmentID
            //            && answ.Is_Requirement == true
            //        select new { req.Requirement_Title, answ.Answer_Text };

            var stmt = from answ in db.ANSWER
                       join mat_q in db.MATURITY_QUESTIONS on answ.Question_Or_Requirement_Id equals mat_q.Mat_Question_Id
                       where answ.Assessment_Id == assessmentID && answ.Question_Type == "Maturity" && mat_q.Question_Title.StartsWith("Stmt")
                       select new { mat_q.Question_Title, answ.Answer_Text };

            var myAnswers = stmt.ToList();

            Dictionary<string, string> answerTranslation = new Dictionary<string, string>
            {
                ["Y"] = "Yes",
                ["N"] = "No",
                ["A"] = "Yes(C)",
                ["U"] = "0",
                ["NA"] = "0",
                ["I"] = "0",
                [""] = "0"
            };

            foreach (var g in myAnswers)
            {

                export.d[g.Question_Title.Substring(5)] = answerTranslation[g.Answer_Text];
            }
        }

        private void ProcessIseAnswers(int assessmentID, ref SingleRowExport export)
        {
            var stmt = from answ in db.ANSWER
                       join mat_q in db.MATURITY_QUESTIONS on answ.Question_Or_Requirement_Id equals mat_q.Mat_Question_Id
                       where answ.Assessment_Id == assessmentID && answ.Question_Type == "Maturity" && mat_q.Question_Title.StartsWith("Stmt")
                       orderby mat_q.Parent_Question_Id
                       select new { mat_q.Question_Title, answ.Answer_Text, mat_q.Maturity_Level_Id };

            var myAnswers = stmt.ToList();

            // removes parent statements "1", "2", etc that are always unanswered. Leaves "1.1", "1.2", etc
            myAnswers = myAnswers.Where(s => s.Question_Title.Contains('.')).ToList();

            Dictionary<string, string> answerTranslation = new Dictionary<string, string>
            {
                ["Y"] = "Yes",
                ["N"] = "No",
                ["U"] = "U",
            };

            foreach (var g in myAnswers)
            {
                if (g.Maturity_Level_Id == 17)
                {
                    export.d[g.Question_Title] = answerTranslation[g.Answer_Text];
                }
                else if (g.Maturity_Level_Id == 18)
                {
                    var modifiedTitle = g.Question_Title + 'c';
                    export.d[modifiedTitle] = answerTranslation[g.Answer_Text];

                }
                else if (g.Maturity_Level_Id == 19)
                {
                    var modifiedTitle = g.Question_Title + "c+";
                    export.d[modifiedTitle] += answerTranslation[g.Answer_Text];
                }
            }
        }
    }



    /// <summary>
    /// Defines the column names and values in a single NCUA export row.
    /// </summary>
    public class SingleRowExport
    {
        public Dictionary<string, string> d = new Dictionary<string, string>();


        /// <summary>
        /// Constructor.
        /// </summary>
        public SingleRowExport()
        {
            foreach (string h in headers)
            {
                d.Add(h, string.Empty);
            }
        }

        public SingleRowExport(string type)
        {
            foreach (string h in iseHeaders)
            {
                d.Add(h, string.Empty);
            }
        }


        /// <summary>
        /// Returns a CSV of all the known values.
        /// </summary>
        /// <returns></returns>
        public string ValuesAsCSV()
        {
            StringBuilder sb = new StringBuilder();
            foreach (string h in headers)
            {
                sb.Append(this.d[h]).Append(",");
            }

            return sb.ToString().TrimEnd(',');
        }


        /// <summary>
        /// Returns a CSV of the headers.
        /// </summary>
        /// <returns></returns>
        public string HeadersAsCSV()
        {
            StringBuilder sb = new StringBuilder();
            foreach (string h in headers)
            {
                if (h.EndsWith("[FACTOR]"))
                {
                    sb.Append(h.Substring(0, h.Length - 8));
                }
                else if (h.EndsWith("[COMPONENT]"))
                {
                    sb.Append(h.Substring(0, h.Length - 11));
                }
                else
                {
                    sb.Append(h);
                }

                sb.Append(",");
            }

            return sb.ToString().TrimEnd(',');
        }

        /// <summary>
        /// Returns a DataTable containing all known values.
        /// </summary>
        /// <returns></returns>
        public DataTable ToDataTable()
        {
            DataTable dt = new DataTable();
            foreach (string h in this.d.Keys)
            {
                dt.Columns.Add(h);
            }
            DataRow row = dt.NewRow();
            dt.Rows.Add(row);

            foreach (DataColumn col in dt.Columns)
            {
                row[col.ColumnName] = this.d[col.ColumnName];
            }

            return dt;
        }


        #region header definitions

        /// <summary>
        /// Spreadsheet headers.  Some headers are duplicates,
        /// and are marked with [FACTOR] or [COMPONENT] suffixes in the
        /// definition.  Those brackets are stripped out of the final
        /// list of headers.
        /// </summary>
        private static string[] headers = new String[] {
                "Version",
                "Assessment Name",
                "CU Name",
                "CU #",
                "Assets",
                "IRPC1",
                "IRPC2",
                "IRPC3",
                "IRPC4",
                "IRPC5",
                "IRP1",
                "IRP2",
                "IRP3",
                "IRP4",
                "IRP5",
                "IRP6",
                "IRP7",
                "IRP8",
                "IRP9",
                "IRP10",
                "IRP11",
                "IRP12",
                "IRP13",
                "IRP14",
                "IRP15",
                "IRP16",
                "IRP17",
                "IRP18",
                "IRP19",
                "IRP20",
                "IRP21",
                "IRP22",
                "IRP23",
                "IRP24",
                "IRP25",
                "IRP26",
                "IRP27",
                "IRP28",
                "IRP29",
                "IRP30",
                "IRP31",
                "IRP32",
                "IRP33",
                "IRP34",
                "IRP35",
                "IRP36",
                "IRP37",
                "IRP38",
                "IRP39",
                "Dom Mat 1",
                "Dom Mat 2",
                "Dom Mat 3",
                "Dom Mat 4",
                "Dom Mat 5",

                "Governance",
                "Risk Management",
                "Resources",
                "Training & Culture",
                "Threat Intelligence",
                "Monitoring & Analyzing",
                "Information Sharing[FACTOR]",
                "Preventative Controls",
                "Detective Controls",
                "Corrective Controls",
                "Connections[FACTOR]",
                "Relationship Management",
                "Incident Resilience Planning and Strategy",
                "Detection, Response, and Mitigation",
                "Escalation and Reporting[FACTOR]",

                "Oversight",
                "Strategy / Policies",
                "IT Asset Management",
                "Risk Management Program",
                "Risk Assessment",
                "Audit",
                "Staffing",
                "Training",
                "Culture",
                "Threat Intelligence and Information",
                "Monitoring and Analyzing",
                "Information Sharing[COMPONENT]",
                "Infrastructure Management",
                "Access and Data Management",
                "Device / End-Point Security",
                "Secure Coding",
                "Threat and Vulnerability Detection",
                "Anomalous Activity Detection",
                "Event Detection",
                "Patch Management",
                "Remediation",
                "Connections[COMPONENT]",
                "Due Diligence",
                "Contracts",
                "Ongoing Monitoring",
                "Planning",
                "Testing",
                "Detection",
                "Response and Mitigation",
                "Escalation and Reporting[COMPONENT]",

                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16",
                "17",
                "18",
                "19",
                "20",
                "21",
                "22",
                "23",
                "24",
                "25",
                "26",
                "27",
                "28",
                "29",
                "30",
                "31",
                "32",
                "33",
                "34",
                "35",
                "36",
                "37",
                "38",
                "39",
                "40",
                "41",
                "42",
                "43",
                "44",
                "45",
                "46",
                "47",
                "48",
                "49",
                "50",
                "51",
                "52",
                "53",
                "54",
                "55",
                "56",
                "57",
                "58",
                "59",
                "60",
                "61",
                "62",
                "63",
                "64",
                "65",
                "66",
                "67",
                "68",
                "69",
                "70",
                "71",
                "72",
                "73",
                "74",
                "75",
                "76",
                "77",
                "78",
                "79",
                "80",
                "81",
                "82",
                "83",
                "84",
                "85",
                "86",
                "87",
                "88",
                "89",
                "90",
                "91",
                "92",
                "93",
                "94",
                "95",
                "96",
                "97",
                "98",
                "99",
                "100",
                "101",
                "102",
                "103",
                "104",
                "105",
                "106",
                "107",
                "108",
                "109",
                "110",
                "111",
                "112",
                "113",
                "114",
                "115",
                "116",
                "117",
                "118",
                "119",
                "120",
                "121",
                "122",
                "123",
                "124",
                "125",
                "126",
                "127",
                "128",
                "129",
                "130",
                "131",
                "132",
                "133",
                "134",
                "135",
                "136",
                "137",
                "138",
                "139",
                "140",
                "141",
                "142",
                "143",
                "144",
                "145",
                "146",
                "147",
                "148",
                "149",
                "150",
                "151",
                "152",
                "153",
                "154",
                "155",
                "156",
                "157",
                "158",
                "159",
                "160",
                "161",
                "162",
                "163",
                "164",
                "165",
                "166",
                "167",
                "168",
                "169",
                "170",
                "171",
                "172",
                "173",
                "174",
                "175",
                "176",
                "177",
                "178",
                "179",
                "180",
                "181",
                "182",
                "183",
                "184",
                "185",
                "186",
                "187",
                "188",
                "189",
                "190",
                "191",
                "192",
                "193",
                "194",
                "195",
                "196",
                "197",
                "198",
                "199",
                "200",
                "201",
                "202",
                "203",
                "204",
                "205",
                "206",
                "207",
                "208",
                "209",
                "210",
                "211",
                "212",
                "213",
                "214",
                "215",
                "216",
                "217",
                "218",
                "219",
                "220",
                "221",
                "222",
                "223",
                "224",
                "225",
                "226",
                "227",
                "228",
                "229",
                "230",
                "231",
                "232",
                "233",
                "234",
                "235",
                "236",
                "237",
                "238",
                "239",
                "240",
                "241",
                "242",
                "243",
                "244",
                "245",
                "246",
                "247",
                "248",
                "249",
                "250",
                "251",
                "252",
                "253",
                "254",
                "255",
                "256",
                "257",
                "258",
                "259",
                "260",
                "261",
                "262",
                "263",
                "264",
                "265",
                "266",
                "267",
                "268",
                "269",
                "270",
                "271",
                "272",
                "273",
                "274",
                "275",
                "276",
                "277",
                "278",
                "279",
                "280",
                "281",
                "282",
                "283",
                "284",
                "285",
                "286",
                "287",
                "288",
                "289",
                "290",
                "291",
                "292",
                "293",
                "294",
                "295",
                "296",
                "297",
                "298",
                "299",
                "300",
                "301",
                "302",
                "303",
                "304",
                "305",
                "306",
                "307",
                "308",
                "309",
                "310",
                "311",
                "312",
                "313",
                "314",
                "315",
                "316",
                "317",
                "318",
                "319",
                "320",
                "321",
                "322",
                "323",
                "324",
                "325",
                "326",
                "327",
                "328",
                "329",
                "330",
                "331",
                "332",
                "333",
                "334",
                "335",
                "336",
                "337",
                "338",
                "339",
                "340",
                "341",
                "342",
                "343",
                "344",
                "345",
                "346",
                "347",
                "348",
                "349",
                "350",
                "351",
                "352",
                "353",
                "354",
                "355",
                "356",
                "357",
                "358",
                "359",
                "360",
                "361",
                "362",
                "363",
                "364",
                "365",
                "366",
                "367",
                "368",
                "369",
                "370",
                "371",
                "372",
                "373",
                "374",
                "375",
                "376",
                "377",
                "378",
                "379",
                "380",
                "381",
                "382",
                "383",
                "384",
                "385",
                "386",
                "387",
                "388",
                "389",
                "390",
                "391",
                "392",
                "393",
                "394",
                "395",
                "396",
                "397",
                "398",
                "399",
                "400",
                "401",
                "402",
                "403",
                "404",
                "405",
                "406",
                "407",
                "408",
                "409",
                "410",
                "411",
                "412",
                "413",
                "414",
                "415",
                "416",
                "417",
                "418",
                "419",
                "420",
                "421",
                "422",
                "423",
                "424",
                "425",
                "426",
                "427",
                "428",
                "429",
                "430",
                "431",
                "432",
                "433",
                "434",
                "435",
                "436",
                "437",
                "438",
                "439",
                "440",
                "441",
                "442",
                "443",
                "444",
                "445",
                "446",
                "447",
                "448",
                "449",
                "450",
                "451",
                "452",
                "453",
                "454",
                "455",
                "456",
                "457",
                "458",
                "459",
                "460",
                "461",
                "462",
                "463",
                "464",
                "465",
                "466",
                "467",
                "468",
                "469",
                "470",
                "471",
                "472",
                "473",
                "474",
                "475",
                "476",
                "477",
                "478",
                "479",
                "480",
                "481",
                "482",
                "483",
                "484",
                "485",
                "486",
                "487",
                "488",
                "489",
                "490",
                "491",
                "492",
                "493",
                "494"
            };

        private static string[] iseHeaders = new String[] {
            "Version",
            "Assessment Name",
            "CU Name",
            "CU #",
            "Assets",
            "IRP1",
            "IRP2",
            "IRP3",
            "IRP4",
            "IRP5",
            "IRP6",
            "IRP7",
            "IRP8",
            "IRP9",
            "Stmt 1.1",
            "Stmt 1.2",
            "Stmt 1.3",
            "Stmt 1.4",
            "Stmt 1.5",
            "Stmt 1.6",
            "Stmt 1.7",
            "Stmt 1.8",
            "Stmt 2.1",
            "Stmt 2.2",
            "Stmt 2.3",
            "Stmt 2.4",
            "Stmt 3.1",
            "Stmt 3.2",
            "Stmt 3.3",
            "Stmt 3.4",
            "Stmt 3.5",
            "Stmt 4.1",
            "Stmt 4.2",
            "Stmt 4.3",
            "Stmt 4.4",
            "Stmt 4.5",
            "Stmt 4.6",
            "Stmt 5.1",
            "Stmt 5.2",
            "Stmt 5.3",
            "Stmt 5.4",
            "Stmt 5.5",
            "Stmt 5.6",
            "Stmt 5.7",
            "Stmt 5.8",
            "Stmt 5.9",
            "Stmt 6.1",
            "Stmt 6.2",
            "Stmt 6.3",
            "Stmt 6.4",
            "Stmt 6.5",
            "Stmt 7.1",
            "Stmt 7.2",
            "Stmt 7.3",
            "Stmt 7.4",
            "Stmt 8.1",
            "Stmt 8.2",
            "Stmt 8.3",
            "Stmt 8.4",
            "Stmt 8.5",
            "Stmt 8.6",
            "Stmt 1.1c",
            "Stmt 1.2c",
            "Stmt 1.3c",
            "Stmt 1.4c",
            "Stmt 1.5c",
            "Stmt 1.6c",
            "Stmt 1.7c",
            "Stmt 1.8c",
            "Stmt 1.9c+",
            "Stmt 1.10c+",
            "Stmt 1.11c+",
            "Stmt 1.12c+",
            "Stmt 1.13c+",
            "Stmt 2.1c",
            "Stmt 2.2c",
            "Stmt 2.3c",
            "Stmt 2.4c",
            "Stmt 2.5c+",
            "Stmt 2.6c+",
            "Stmt 2.7c+",
            "Stmt 2.8c+",
            "Stmt 2.9c+",
            "Stmt 3.1c",
            "Stmt 3.2c",
            "Stmt 3.3c",
            "Stmt 3.4c",
            "Stmt 3.5c",
            "Stmt 3.6c+",
            "Stmt 3.7c+",
            "Stmt 3.8c+",
            "Stmt 3.9c+",
            "Stmt 3.10c+",
            "Stmt 3.11c+",
            "Stmt 3.12c+",
            "Stmt 3.13c+",
            "Stmt 4.1c",
            "Stmt 4.2c",
            "Stmt 4.3c",
            "Stmt 4.4c",
            "Stmt 4.5c",
            "Stmt 4.6c+",
            "Stmt 4.7c+",
            "Stmt 4.8c+",
            "Stmt 4.9c+",
            "Stmt 4.10c+",
            "Stmt 4.11c+",
            "Stmt 4.12c+",
            "Stmt 4.13c+",
            "Stmt 4.14c+",
            "Stmt 4.15c+",
            "Stmt 4.16c+",
            "Stmt 4.17c+",
            "Stmt 4.18c+",
            "Stmt 5.1c",
            "Stmt 5.2c",
            "Stmt 5.3c",
            "Stmt 5.4c",
            "Stmt 5.5c",
            "Stmt 5.6c",
            "Stmt 5.7c+",
            "Stmt 5.8c+",
            "Stmt 5.9c+",
            "Stmt 5.10c+",
            "Stmt 5.11c+",
            "Stmt 5.12c+",
            "Stmt 6.1c",
            "Stmt 6.2c",
            "Stmt 6.3c+",
            "Stmt 6.4c+",
            "Stmt 6.5c+",
            "Stmt 7.1c",
            "Stmt 7.2c",
            "Stmt 7.3c",
            "Stmt 7.4c",
            "Stmt 7.5c",
            "Stmt 7.6c",
            "Stmt 7.7c+",
            "Stmt 7.8c+",
            "Stmt 7.9c+",
            "Stmt 7.10c+",
            "Stmt 7.11c+",
            "Stmt 7.12c+",
            "Stmt 7.13c+",
            "Stmt 8.1c",
            "Stmt 8.2c",
            "Stmt 8.3c",
            "Stmt 8.4c",
            "Stmt 8.5c",
            "Stmt 8.6c",
            "Stmt 8.7c",
            "Stmt 8.8c",
            "Stmt 8.9c",
            "Stmt 8.10c+",
            "Stmt 8.11c+",
            "Stmt 8.12c+",
            "Stmt 8.13c+",
            "Stmt 8.14c+",
            "Stmt 8.15c+",
            "Stmt 8.16c+",
            "Stmt 8.17c+",
            "Stmt 8.18c+",
            "Stmt 9.1c",
            "Stmt 9.2c",
            "Stmt 9.3c",
            "Stmt 9.4c",
            "Stmt 9.5c",
            "Stmt 9.6c+",
            "Stmt 9.7c+",
            "Stmt 9.8c+",
            "Stmt 9.9c+",
            "Stmt 9.10c+",
            "Stmt 9.11c+",
            "Stmt 9.12c+",
            "Stmt 9.13c+",
            "Stmt 9.14c+",
            "Stmt 9.15c+",
            "Stmt 9.16c+",
            "Stmt 9.17c+",
            "Stmt 9.18c+",
            "Stmt 9.19c+",
            "Stmt 9.20c+",
            "Stmt 9.21c+",
            "Stmt 10.1c",
            "Stmt 10.2c",
            "Stmt 10.3c",
            "Stmt 10.4c",
            "Stmt 10.5c+",
            "Stmt 10.6c+",
            "Stmt 10.7c+",
            "Stmt 10.8c+",
            "Stmt 10.9c+",
            "Stmt 10.10c+",
            "Stmt 10.11c+",
            "Stmt 10.12c+",
            "Stmt 11.1c",
            "Stmt 11.2c",
            "Stmt 11.3c",
            "Stmt 11.4c+",
            "Stmt 11.5c+",
            "Stmt 11.6c+",
            "Stmt 11.7c+",
            "Stmt 11.8c+",
            "Stmt 11.9c+",
            "Stmt 11.10c+",
            "Stmt 11.11c+",
            "Stmt 11.12c+",
            "Stmt 11.13c+",
            "Stmt 11.14c+",
            "Stmt 12.1c",
            "Stmt 12.2c",
            "Stmt 12.3c",
            "Stmt 12.4c+",
            "Stmt 12.5c+",
            "Stmt 12.6c+",
            "Stmt 12.7c+",
            "Stmt 12.8c+",
            "Stmt 12.9c+",
            "Stmt 12.10c+",
            "Stmt 12.11c+",
            "Stmt 12.12c+",
            "Stmt 12.13c+",
            "Stmt 12.14c+",
            "Stmt 12.15c+",
            "Stmt 13.1c",
            "Stmt 13.2c",
            "Stmt 13.3c",
            "Stmt 13.4c+",
            "Stmt 13.5c+",
            "Stmt 13.6c+",
            "Stmt 13.7c+",
            "Stmt 13.8c+",
            "Stmt 13.9c+",
            "Stmt 13.10c+",
            "Stmt 13.11c+",
            "Stmt 13.12c+",
            "Stmt 13.13c+",
            "Stmt 13.14c+",
            "Stmt 13.15c+",
            "Stmt 13.16c+",
            "Stmt 13.17c+",
            "Stmt 13.18c+",
            "Stmt 13.19c+",
            "Stmt 13.20c+",
            "Stmt 13.21c+",
            "Stmt 13.22c+",
            "Stmt 14.1c",
            "Stmt 14.2c",
            "Stmt 14.3c+",
            "Stmt 14.4c+",
            "Stmt 14.5c+",
            "Stmt 14.6c+",
            "Stmt 14.7c+",
            "Stmt 14.8c+",
            "Stmt 14.9c+",
            "Stmt 14.10c+",
            "Stmt 14.11c+",
            "Stmt 14.12c+",
            "Stmt 14.13c+",
            "Stmt 14.14c+",
            "Stmt 15.1c",
            "Stmt 15.2c",
            "Stmt 15.3c",
            "Stmt 15.4c",
            "Stmt 15.5c+",
            "Stmt 15.6c+",
            "Stmt 15.7c+",
            "Stmt 15.8c+",
            "Stmt 15.9c+",
            "Stmt 15.10c+",
            "Stmt 15.11c+",
            "Stmt 15.12c+",
            "Stmt 15.13c+",
            "Stmt 16.1c",
            "Stmt 16.2c",
            "Stmt 16.3c+",
            "Stmt 16.4c+",
            "Stmt 16.5c+",
            "Stmt 16.6c+",
            "Stmt 16.7c+",
            "Stmt 16.8c+",
            "Stmt 16.9c+",
            "Stmt 16.10c+",
            "Stmt 16.11c+",
            "Stmt 16.12c+",
            "Stmt 16.13c+",
            "Stmt 16.14c+",
            "Stmt 16.15c+",
            "Stmt 17.1c+",
            "Stmt 17.2c+",
            "Stmt 17.3c+",
            "Stmt 17.4c+",
            "Stmt 17.5c+",
            "Stmt 17.6c+",
            "Stmt 17.7c+",
            "Stmt 17.8c+",
            "Stmt 17.9c+",
            "Stmt 17.10c+",
            "Stmt 17.11c+",
            "Stmt 17.12c+",
            "Stmt 17.13c+",
            "Stmt 17.14c+",
            "Stmt 17.15c+",
            "Stmt 18.1c+",
            "Stmt 18.2c+",
            "Stmt 18.3c+",
            "Stmt 18.4c+",
            "Stmt 18.5c+",
            "Stmt 19.1c+",
            "Stmt 19.2c+",
            "Stmt 19.3c+",
            "Stmt 19.4c+",
            "Stmt 19.5c+",
            "Stmt 19.6c+",
            "Stmt 19.7c+",
            "Stmt 19.8c+",
            "Stmt 19.9c+",
            "Stmt 19.10c+",
            "Stmt 19.11c+",
            "Stmt 19.12c+",
            "Stmt 19.13c+",
            "Stmt 19.14c+",
            "Stmt 19.15c+",
            "Stmt 20.1c+",
            "Stmt 20.2c+",
            "Stmt 20.3c+",
            "Stmt 20.4c+",
            "Stmt 20.5c+",
            "Stmt 20.6c+",
            "Stmt 20.7c+",
            "Stmt 20.8c+",
            "Stmt 20.9c+",
            "Stmt 20.10c+",
            "Stmt 21.1c+",
            "Stmt 21.2c+",
            "Stmt 21.3c+",
            "Stmt 21.4c+",
            "Stmt 21.5c+",
            "Stmt 21.6c+",
            "Stmt 21.7c+",
            "Stmt 21.8c+",
            "Stmt 21.9c+",
            "Stmt 22.1c+",
            "Stmt 22.2c+",
            "Stmt 22.3c+",
            "Stmt 22.4c+",
            "Stmt 22.5c+",
            "Stmt 22.6c+",
            "Stmt 23.1c+",
            "Stmt 23.2c+",
            "Stmt 23.3c+",
            "Stmt 23.4c+",
            "Stmt 23.5c+",
            "Stmt 23.6c+",
            "Stmt 23.7c+",
            "Stmt 23.8c+",
            "Stmt 23.9c+",
            "Stmt 23.10c+",
            "Stmt 23.11c+",
            "Stmt 23.12c+",
            "Stmt 23.13c+",
            "Stmt 23.14c+",
            "Stmt 23.15c+",
            "Stmt 23.16c+",
            "Stmt 23.17c+",
            "Stmt 23.18c+",
            "Stmt 23.19c+",
            "Stmt 23.20c+",
            "Stmt 23.21c+",
            "Stmt 23.22c+",
            "Stmt 23.23c+",
            "Stmt 23.24c+",
            "Stmt 23.25c+",
            "Stmt 23.26c+",
            "Stmt 23.27c+",
            "Stmt 23.28c+",
            "Stmt 24.1c+",
            "Stmt 24.2c+",
            "Stmt 24.3c+",
            "Stmt 24.4c+",
            "Stmt 24.5c+",
            "Stmt 24.6c+",
            "Stmt 24.7c+",
            "Stmt 24.8c+",
            "Stmt 24.9c+",
            "Stmt 24.10c+",
            "Stmt 24.11c+",
            "Stmt 24.12c+",
            "Stmt 24.13c+",
            "Stmt 24.14c+",
            "Stmt 24.15c+",
            "Stmt 24.16c+",
            "Stmt 24.17c+",
            "Stmt 24.18c+",
            "Stmt 25.1c+",
            "Stmt 25.2c+",
            "Stmt 25.3c+",
            "Stmt 25.4c+",
            "Stmt 25.5c+",
            "Stmt 25.6c+",
            "Stmt 25.7c+",
            "Stmt 25.8c+",
            "Stmt 25.9c+",
            "Stmt 25.10c+",
            "Stmt 25.11c+",
            "Stmt 25.12c+",
            "Stmt 25.13c+",
            "Stmt 25.14c+",
            "Stmt 25.15c+",
            "Stmt 25.16c+",
            "Stmt 25.17c+",
            "Stmt 25.18c+",
            "Stmt 25.19c+",
            "Stmt 25.20c+",
            "Stmt 25.21c+",
            "Stmt 25.22c+",
            "Stmt 25.23c+",
            "Stmt 25.24c+",
            "Stmt 25.25c+",
            "Stmt 25.26c+",
            "Stmt 25.27c+",
            "Stmt 25.28c+",
            "Stmt 25.29c+",
            "Stmt 25.30c+",
            "Stmt 25.31c+",
            "Stmt 25.32c+",
            "Stmt 25.33c+",
            "Stmt 25.34c+",
            "Stmt 25.35c+"
        };
        #endregion
    }
}