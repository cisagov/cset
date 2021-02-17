//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Drawing;
using System.IO;
using System.Collections.Generic;
using System;
using CSET_Main.ReportEngine.Contract;



namespace CSET_Main.ReportEngine.Common
{
    public class ReportImage
    {
        public ReportImageStateEnum ImageReportState { get; set; }
        /// <summary>
        /// Not really used except for debugging
        /// </summary>
        public string PathToOriginal { get; set; }
        public Image ModifiedImage { get; set; }

        private ChartToImageBuilderNoWindow chartToImage = new ChartToImageBuilderNoWindow();
        //public Image Image;
        public byte[] OriginalHash;
        private static Dictionary<String, byte[]> filePaths = new Dictionary<String, byte[]>();



        /// <summary>
        /// CONSTRUCTOR
        /// </summary>
        /// <param name="PathToOriginal"></param>
        public ReportImage(string PathToOriginal, ReportImageStateEnum reportsSupported)
        {
            this.PathToOriginal = PathToOriginal;

            this.ImageReportState = reportsSupported;
            if (filePaths.ContainsKey(PathToOriginal))
            {
                OriginalHash = filePaths[PathToOriginal];
            }
            else
            {
                byte[] bytes = File.ReadAllBytes(PathToOriginal);
                OriginalHash = ImageHasher.Hash(bytes);
                filePaths.Add(PathToOriginal, OriginalHash);
            }
        }

        /// <summary>
        /// OVERLOADED CONSTRUCTOR
        /// </summary>
        /// <param name="PathToOriginal"></param>
        /// <param name="control"></param>
        public ReportImage(string PathToOriginal, System.Windows.Controls.UserControl control, ReportImageStateEnum reportsSupported)
            : this(PathToOriginal, reportsSupported)
        {
            this.ModifiedImage = chartToImage.SaveChartAsImage(control);
        }

        /// <summary>
        /// Use this if you have an image instead of UserControl
        /// </summary>
        /// <param name="image"></param>
        public ReportImage(string PathToOriginal, Image image, ReportImageStateEnum reportsSupported)
            : this(PathToOriginal, reportsSupported)
        {
            this.ModifiedImage = image;
        }

        public ImageHash GetImageHash()
        {
            return new ImageHash()
            {
                hashOfOldImage = OriginalHash,
                NewImage = ModifiedImage,
                PathToOriginal = PathToOriginal,
                ImageReportState = this.ImageReportState
            };
        }



    }
}


