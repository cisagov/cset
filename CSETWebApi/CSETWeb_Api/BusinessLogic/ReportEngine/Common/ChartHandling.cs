//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace CSET_Main.ReportEngine.Common
{
    public class ChartHandling {
        
        public Image MergeImages(MemoryStream overlayImage, Image baseImage) {
         
            Bitmap bitmap = (Bitmap)Bitmap.FromStream(overlayImage);
            bitmap = scaleImage(bitmap);

            bitmap.MakeTransparent(Color.White);

            GraphicsUnit units = GraphicsUnit.Document;
            RectangleF rect = baseImage.GetBounds(ref units);
            Bitmap newImage = new Bitmap(baseImage.Width, baseImage.Height);

            Graphics g = Graphics.FromImage(newImage);
            g.FillRectangle(Brushes.White, 0, 0, baseImage.Width, baseImage.Height);
            g.DrawImage(baseImage, 0, 0, baseImage.Width, baseImage.Height);
            Point p = centerOverlayImage(bitmap, baseImage);
            g.DrawImageUnscaled(bitmap, p.X, p.Y);
            g.ScaleTransform(.25f, .25f);
            g.Flush();

            Image rimage;
            using (MemoryStream ms = new MemoryStream())
            {
                newImage.Save(ms, ImageFormat.Jpeg);
                rimage = Image.FromStream(ms);
                ms.Close();                
            }

            return rimage;
        }

        private Bitmap scaleImage(Bitmap image) {
            Graphics g = Graphics.FromImage(image);
            g.ScaleTransform(1.25f, 1.25f);
            g.Flush();
            return image;
        }

        public Point centerOverlayImage(Image overlay, Image baseImage) {
            //take the difference between the two images
            //divide by 2 and set as the point
            Point p = new Point();
            p.Y = (baseImage.Height - overlay.Height) / 2;
            p.X = (baseImage.Width - overlay.Width) / 2;
            return p;
        }
    }
}


