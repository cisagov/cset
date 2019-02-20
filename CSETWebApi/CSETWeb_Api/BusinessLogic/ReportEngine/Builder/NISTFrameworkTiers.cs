//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.ReportEngine.Builder
{
    class NISTFrameworkTiers
    {

        private DataHandling cb = new DataHandling();
        private Dictionary<String, TierObject> tiers = new Dictionary<string, TierObject>();


        public NISTFrameworkTiers()
        {
            //fill the main three with results 
            //then calculate the overall
            tiers.Add("Overall", new TierObject(){
                TableName = "NISTFrameworkOverallTable"
            });
            tiers.Add("External Participation",new TierObject(){
                TableName = "NISTFrameworkEPTable",
                TierType= "External Participation"
            });
            tiers.Add("Integrated Risk Management Program",new TierObject(){
                TableName = "NISTFrameworkIRMPTable",
                TierType = "Integrated Risk Management Program"
            });
            tiers.Add("Risk Management Process",new TierObject(){
                TableName= "NISTFrameworkRMPTable",
                TierType = "Risk Management Process"
            });
            
        }

        public List<DataTable> GetNistTables(CSET_Context context, int assessment_id)
        {
            List<DataTable> nistTables = new List<DataTable>();


            var s = from a in context.FRAMEWORK_TIER_DEFINITIONS
                    join b in context.FRAMEWORK_TIER_TYPE_ANSWER on new { a.Tier, a.TierType } equals new { b.Tier, b.TierType }                    
                    join c in context.FRAMEWORK_TIERS  on b.Tier equals c.Tier                    
                    where b.Assessment_Id == assessment_id
                    select new { TA = a, T = c };

            foreach (var t in s)
            {
                TierObject to;
                if (tiers.TryGetValue(t.TA.TierType, out to))
                {
                    to.Tier = t.TA.Tier;
                    to.TierOrder = t.T.TierOrder;
                    to.TierDescription = t.TA.TierQuestion;
                    nistTables.Add(BuildNISTFrameworkTable(to));
                }
            }
            TierObject overall = tiers["Overall"];
            //find the low water mark and set overall to the 
            //lowest
            int Max = 1000;
            TierObject lowest = null;
          
            foreach (TierObject to in tiers.Values)
            {
                if (to.TierOrder > 0)
                    if (to.TierOrder < Max)
                    {
                        Max = to.TierOrder;
                        lowest = to;
                    }
            }
            overall.Tier = lowest.Tier;
            nistTables.Add(BuildNISTFrameworkTable(overall));

            return nistTables;
        }


        /// <summary>
        /// Builds the data table for the reports NIST Framework Tiers NISTFrameworkOverallTable
        /// </summary>
        /// <returns></returns>
        private DataTable BuildNISTFrameworkTable(TierObject myTier)
        {
            DataTable table = new DataTable();
            table.TableName = myTier.TableName;
            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("TierLevel"));
            table.Columns.Add(cb.BuildTableColumn("TierDescription"));

            if (myTier != null)
            {
                DataRow row = table.NewRow();
                row["TierLevel"] = myTier.Tier;
                row["TierDescription"] = myTier.TierDescription;
                table.Rows.Add(row);
            }
            else
            {
                cb.WriteEmptyMessage(table, "Tiers", "There is no tier data to display.");
            }
            return table;
        }











    }
}


