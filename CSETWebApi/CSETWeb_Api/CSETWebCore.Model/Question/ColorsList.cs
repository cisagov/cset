//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class ColorsList
    {
        private int next = 0;
        static String[] brushes = new String[20];

        static ColorsList()
        {
            brushes[0] = "#007BFF"; // Brushes.Blue
            brushes[1] = "#FFD700"; // Brushes.Gold;
            brushes[2] = "#008000"; // Brushes.Green;
            brushes[3] = "#6495ED"; // Brushes.CornflowerBlue;
            brushes[4] = "#006400"; // Brushes.DarkGreen;
            brushes[5] = "#F0E68C"; // Brushes.Khaki;
            brushes[6] = "#00008B"; // Brushes.DarkBlue;
            brushes[7] = "#008B8B"; // Brushes.DarkCyan;
            brushes[8] = "#FFFACD"; // Brushes.LemonChiffon;
            brushes[9] = "#483D8B"; // Brushes.DarkSlateBlue;
            brushes[10] = "#2F4F4F"; // Brushes.DarkSlateGray;
            brushes[11] = "#9400D3"; // Brushes.DarkViolet;
            brushes[12] = "#1E90FF"; // Brushes.DodgerBlue;
            brushes[13] = "#B22222"; // Brushes.Firebrick;
            brushes[14] = "#FFFAF0"; // Brushes.FloralWhite;
            brushes[15] = "#228B22"; // Brushes.ForestGreen;
            brushes[16] = "#DAA520"; // Brushes.Goldenrod;
            brushes[17] = "#ADFF2F"; // Brushes.GreenYellow;
            brushes[18] = "#4B0082"; // Brushes.Indigo;
            brushes[19] = "#000080"; // Brushes.Navy;
        }

        private String getNext()
        {
            return brushes[next++ % 20];
        }

        /// <summary>
        /// give standard / set_name returns a color
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public string getNext(string key)
        {
            string rval;
            if (!brushesByName.TryGetValue(key, out rval))
            {
                rval = getNext();
                brushesByName.Add(key, rval);
            }
            return rval;
        }

        public void Clear()
        {
            brushesByName.Clear();
        }
        /// <summary>
        /// set_name, coresponding assigned color
        /// </summary>
        private Dictionary<String, string> brushesByName = new Dictionary<string, string>();
    }
}