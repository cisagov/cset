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
using System.Text;
using CSETWebCore.Business.Diagram;
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.ExportCSV
{
    public class CSETtoExcelDiagramMappings
    {
        private CSETContext db;
        private readonly IHttpContextAccessor _http;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="db"></param>
        public CSETtoExcelDiagramMappings(CSETContext db, IHttpContextAccessor http)
        {
            this.db = db;
            _http = http;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="stream"></param>
        public void ProcessDiagram(int assessmentId, MemoryStream stream)
        {
            DataTable dtComponents = BuildDiagramComponents(assessmentId);
            DataTable dtZones = BuildDiagramZones(assessmentId);
            DataTable dtLinks = BuildDiagramLinks(assessmentId);
            DataTable dtShapes = BuildDiagramShapes(assessmentId);
            DataTable dtTexts = BuildDiagramText(assessmentId);

            // Create an Excel document from the data that has been gathered
            var doc = new CSETtoExcelDocument();
            doc.AddDataTable(dtComponents);
            doc.AddDataTable(dtZones);
            doc.AddDataTable(dtLinks);
            doc.AddDataTable(dtShapes);
            doc.AddDataTable(dtTexts);

            List<DataMap> list = new List<DataMap>();
            doc.WriteExcelFile(stream, list);
        }

        public DataTable BuildDiagramComponents(int assessmentId)
        {
            var dm = new DiagramManager(db);
            var diagramXml = dm.GetDiagramXml(assessmentId);
            var vertices = dm.ProcessDiagramVertices(diagramXml, assessmentId);
            var components = dm.GetDiagramComponents(vertices);


            // Build the row for the assessment
            var export = new SingleDiagramRowExport();

            var datatable = new DataTable();
            datatable.Columns.Add("Label", typeof(System.String));
            datatable.Columns.Add("Has Unique Questions", typeof(System.String));
            datatable.Columns.Add("Sal", typeof(System.String));
            datatable.Columns.Add("Criticality", typeof(System.String));
            datatable.Columns.Add("Layer", typeof(System.String));
            datatable.Columns.Add("Ip Address", typeof(System.String));
            datatable.Columns.Add("Asset Type", typeof(System.String));
            datatable.Columns.Add("Zone", typeof(System.String));
            datatable.Columns.Add("Subnet Name", typeof(System.String));
            datatable.Columns.Add("Description", typeof(System.String));
            datatable.Columns.Add("Host Name", typeof(System.String));
            datatable.Columns.Add("Visible", typeof(System.String));
            datatable.Columns.Add("Vendor Name", typeof(System.String));
            datatable.Columns.Add("Product Name", typeof(System.String));
            datatable.Columns.Add("Version Name", typeof(System.String));
            datatable.Columns.Add("Serial Number", typeof(System.String));
            datatable.Columns.Add("Physical Location", typeof(System.String));


            foreach (var c in components)
            {
                var row = datatable.NewRow();

                row["Label"] = c.label;
                row["Has Unique Questions"] = c.HasUniqueQuestions;
                row["Sal"] = c.SAL;
                row["Criticality"] = c.Criticality;
                row["Layer"] = c.layerName;
                row["Ip Address"] = c.IPAddress;
                row["Asset Type"] = c.assetType;
                row["Zone"] = c.zoneLabel;
                row["Subnet Name"] = string.Empty;
                row["Description"] = c.Description;
                row["Host Name"] = c.HostName;
                row["Visible"] = c.visible;
                row["Vendor Name"] = c.VendorName;
                row["Product Name"] = c.ProductName;
                row["Version Name"] = c.VersionName;
                row["Serial Number"] = c.SerialNumber;
                row["Physical Location"] = c.PhysicalLocation;

                datatable.Rows.Add(row);
            }
            datatable.TableName = "Components";
            return datatable;
        }

        public DataTable BuildDiagramZones(int assessmentId)
        {
            var dm = new DiagramManager(db);
            var diagramXml = dm.GetDiagramXml(assessmentId);
            var vertices = dm.ProcessDiagramVertices(diagramXml, assessmentId);
            var zones = dm.GetDiagramZones(vertices);

            var datatable = new DataTable();
            datatable.Columns.Add("Type", typeof(System.String));
            datatable.Columns.Add("Label", typeof(System.String));
            datatable.Columns.Add("Sal", typeof(System.String));
            datatable.Columns.Add("Layer", typeof(System.String));
            datatable.Columns.Add("Visible", typeof(System.String));


            foreach (var z in zones)
            {
                var row = datatable.NewRow();

                row["Type"] = z.ZoneType;
                row["Label"] = z.label;
                row["Sal"] = z.SAL;
                row["Layer"] = z.layerName;
                row["Visible"] = z.visible;

                datatable.Rows.Add(row);
            }
            datatable.TableName = "Zones";
            return datatable;
        }

        public DataTable BuildDiagramLinks(int assessmentId)
        {
            var dm = new DiagramManager(db);
            var diagramXml = dm.GetDiagramXml(assessmentId);
            var edges = dm.ProcessDiagramEdges(diagramXml, assessmentId);
            var links = dm.GetDiagramLinks(edges);

            var datatable = new DataTable();

            datatable.Columns.Add("Label", typeof(System.String));
            datatable.Columns.Add("Subnet Names", typeof(System.String));
            datatable.Columns.Add("Layer", typeof(System.String));
            datatable.Columns.Add("Visible", typeof(System.String));


            foreach (var l in links)
            {
                var row = datatable.NewRow();

                row["Label"] = l.label;
                row["Subnet Names"] = string.Empty;
                row["Layer"] = l.layerName;
                row["Visible"] = l.visible;

                datatable.Rows.Add(row);
            }
            datatable.TableName = "Links";
            return datatable;
        }

        public DataTable BuildDiagramShapes(int assessmentId)
        {
            var dm = new DiagramManager(db);
            var diagramXml = dm.GetDiagramXml(assessmentId);
            var shapesCells = dm.ProcessDiagramShapes(diagramXml, assessmentId);
            var shapes = dm.GetDiagramShapes(shapesCells);

            var datatable = new DataTable();

            datatable.Columns.Add("Label", typeof(System.String));
            datatable.Columns.Add("Layer", typeof(System.String));
            datatable.Columns.Add("Visible", typeof(System.String));


            foreach (var s in shapes)
            {
                var row = datatable.NewRow();

                row["Label"] = s.value;
                row["Layer"] = s.layerName;
                row["Visible"] = s.visible;

                datatable.Rows.Add(row);
            }

            datatable.TableName = "Shapes";
            return datatable;
        }

        public DataTable BuildDiagramText(int assessmentId)
        {
            var dm = new DiagramManager(db);
            var diagramXml = dm.GetDiagramXml(assessmentId);
            var textCells = dm.ProcessDiagramShapes(diagramXml, assessmentId);
            var texts = dm.GetDiagramText(textCells);

            var datatable = new DataTable();

            datatable.Columns.Add("Label", typeof(System.String));
            datatable.Columns.Add("Layer", typeof(System.String));
            datatable.Columns.Add("Visible", typeof(System.String));


            foreach (var t in texts)
            {
                var row = datatable.NewRow();

                row["Label"] = t.value;
                row["Layer"] = t.layerName;
                row["Visible"] = t.visible;

                datatable.Rows.Add(row);
            }
            datatable.TableName = "Text";
            return datatable;
        }

    }


    /// <summary>
    /// Defines the column names and values in a single NCUA export row.
    /// </summary>
    public class SingleDiagramRowExport
    {
        public Dictionary<string, string> d = new Dictionary<string, string>();


        /// <summary>
        /// Constructor.
        /// </summary>
        public SingleDiagramRowExport()
        {
            foreach (string h in headers)
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
                "Hours",
                "CU ACET for EX",
                "CU Self ACET",
                "Doc Hrs",
                "Int Hrs",
                "Pre Doc",
                "IRP Doc",
                "D1 Doc",
                "D2 Doc",
                "D3 Doc",
                "D4 Doc",
                "D5 Doc",
                "Oth1 Doc",
                "Oth2 Doc",
                "Pre Int",
                "IRP Int",
                "D1 Int",
                "D2 Int",
                "D3 Int",
                "D4 Int",
                "D5 Int",
                "Exit Int",
                "Oth1 Int",
                "Oth2 Int",
                "D1 Rev",
                "D2 Rev",
                "D3 Rev",
                "D4 Rev",
                "D5 Rev",
                "D1 Rvw",
                "D2 Rvw",
                "D3 Rvw",
                "D4 Rvw",
                "D5 Rvw",
                "Tot Rvw",
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

        #endregion
    }
}