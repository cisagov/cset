//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Specialized;
using CSET_Main.Data;
using DataLayerCore.Model;

namespace CSET_Main.ReportEngine.Builder
{
    public class LevelsHandler
    {
        Dictionary<String, Dictionary<String, Boolean>> outputTable = new Dictionary<string, Dictionary<string, Boolean>>();
        String[] Levels = new String[] { "NONE","L", "M", "H", "VH" };
        //note that there are three sections 
        //the LMHVH section, MAC, and then DOD Conf
        //the first true value is where we kick out
        String[] Levels_NO_NONE = new String[] { "L", "M", "H", "VH"};
        String[] Level_Types = new String[] { "C", "I", "A", "NST" };
        String[] Level_Types_NO_NST = new String[] { "C", "I", "A" };
        String[] MAC = new String[] {"MAC I", "MAC II", "MAC III"};
        String[] Conf = new String[] {"P", "S", "C" };
        
        /// <summary>
        /// creates a table of found levels and generates
        /// level strings based upon what is found for each level type
        /// </summary>
        public LevelsHandler()
        {
            foreach (String leveltype in Level_Types)
            {
                outputTable.Add(leveltype, new Dictionary<string, Boolean>());
                
                foreach (String l in Levels)
                    outputTable[leveltype].Add(l, false);                
            }
            
        }

        public String ProcessLevelsList(List<REQUIREMENT_LEVELS> requirementsLevels)
        {
            char[] trimChars = new char[]{',',' ','\r','\n'};
            char[] trimChars2 = new char[] { ',', ' '};

            bool foundCIA = false;
            bool foundMAC = false;
            bool foundDODConf = false;

            foreach (REQUIREMENT_LEVELS level in requirementsLevels)
            {   
                if(level.Level_Type=="C" || level.Level_Type=="I" || level.Level_Type=="A")
                    foundCIA = true;

                outputTable[level.Level_Type.ToUpper()][level.Standard_Level.ToUpper()] = true;
            }

            //removed NST
            if (foundCIA)
                Level_Types = Level_Types_NO_NST;

           StringBuilder sb = new StringBuilder();
           StringBuilder final = new StringBuilder();
           foreach (String leveltype in Level_Types)
           {
                Dictionary<String,bool> row =  outputTable[leveltype];

                Boolean hasValue = false;
                foreach (KeyValuePair<string,bool> b in row)
                    hasValue |= (bool) b.Value;

                    if (foundCIA)
                    {
                        sb.Append(leveltype);
                        sb.Append(": ");
                    }                 
                   
                    foreach (String lvl in Levels_NO_NONE)
                    {
                        Boolean b;
                        if (row.TryGetValue(lvl, out b))
                        {
                            if (b)
                            {  
                                sb.Append(lvl);
                                break;
                            }
                        }
                    }

                    foreach (String lvl in MAC)
                    {
                        Boolean b;
                        if (row.TryGetValue(lvl, out b))
                        {
                            if (b)
                            {
                                sb.AppendLine();
                                sb.Append("MAC: ");
                                sb.Append(lvl);
                                foundMAC = true;
                                break;
                            }
                        }
                    }

                    foreach (String lvl in Conf)
                    {
                        Boolean b;
                        if (row.TryGetValue(lvl, out b))
                        {
                            if (b)
                            {
                                sb.AppendLine();
                                sb.Append("Conf: ");
                                sb.Append(lvl);
                                foundDODConf = true;
                                break;
                            }
                        }
                    }
                    final.AppendLine(sb.ToString().Trim(trimChars2));
                    sb.Clear();
            }

            if (foundDODConf ^ foundMAC)
            {
               foundDODConf = false;
               foundMAC = false;
               return "\r" + final.ToString().Trim(trimChars);
            }
            else
            {
               foundDODConf = false;
               foundMAC = false;
               return final.ToString().Trim(trimChars);
            }
        }
    }
}


