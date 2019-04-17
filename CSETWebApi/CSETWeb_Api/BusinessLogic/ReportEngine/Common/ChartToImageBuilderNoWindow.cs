//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;


namespace CSET_Main.ReportEngine.Common
{
    class ChartToImageBuilderNoWindow
    {
        internal System.Drawing.Image SaveChartAsImage(UserControl barchart)
        {
            double width = barchart.Width;
            double height = barchart.Height;
            System.Drawing.Image img = null;
            Viewbox viewbox = new Viewbox();
            viewbox.Child = barchart;
            viewbox.Measure(Size.Empty);
            viewbox.Measure(new System.Windows.Size(width, height));
            viewbox.Arrange(new Rect(0, 0, width, height));
            viewbox.UpdateLayout();
            using (MemoryStream ms = new MemoryStream())
            {
                RenderTargetBitmap render = new RenderTargetBitmap((int)width, (int)height, 1 / 300, 1 / 300, PixelFormats.Pbgra32);
                render.Render(viewbox);
                PngBitmapEncoder png = new PngBitmapEncoder();
                png.Frames.Add(BitmapFrame.Create(render));
                png.Save(ms);
                ms.Seek(0, SeekOrigin.Begin);
                img = System.Drawing.Image.FromStream(ms);
                ms.Close();
                viewbox.Child = null;
            }

            return img;
        }

        internal byte[] SaveChartAsBytes(UserControl barchart)
        {
            double width = barchart.Width;
            double height = barchart.Height;
            byte[] rval = null;
            Viewbox viewbox = new Viewbox();
            viewbox.Child = barchart;
            viewbox.Measure(Size.Empty);
            viewbox.Measure(new System.Windows.Size(width, height));
            viewbox.Arrange(new Rect(0, 0, width, height));
            viewbox.UpdateLayout();
            using (MemoryStream ms = new MemoryStream())
            {
                
                RenderTargetBitmap render = new RenderTargetBitmap((int)width, (int)height, 1 / 300, 1 / 300, PixelFormats.Pbgra32);
                render.Render(viewbox);
                PngBitmapEncoder png = new PngBitmapEncoder();
                png.Frames.Add(BitmapFrame.Create(render));
                png.Save(ms);
                ms.Seek(0, SeekOrigin.Begin);
                rval = ms.ToArray();
                ms.Close();
                viewbox.Child = null;
            }

            return rval;
        }    
    }
}


