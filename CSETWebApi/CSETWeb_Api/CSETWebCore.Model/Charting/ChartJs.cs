//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

/// <summary>
/// The classes defined here can be used to build input
/// objects for Chart.js in the UI.
/// </summary>
namespace CSETWebCore.Model.Charting
{
    public class BarChartX
    {
        public string ChartName { get; set; }
        public List<string> Labels { get; set; }
        public List<DatasetX> Datasets { get; set; }

        public BarChartX()
        {
            Datasets = new List<DatasetX>();
        }
    }

    public class DatasetX
    {
        /// <summary>
        /// This is the label for the individual bar in the group.
        /// </summary>
        public string Label { get; set; }
        public string BackgroundColor { get; set; }
        public List<double> Data { get; set; }

        public DatasetX()
        {
            Data = new List<double>();
        }
    }

    /*
     
    {
    labels: ["A", "B"],
    datasets: [{
            label: "Domain 1",
            backgroundColor: "#3e95cd",
            data: [42, 33]
        }, {
            label: "Domain 2",
            backgroundColor: "#8e5ea2",
            data: [66.67, 100]
        }
    ]
}
     */
}
