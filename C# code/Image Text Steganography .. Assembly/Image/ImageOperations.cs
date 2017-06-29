using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Drawing.Imaging;
using System.IO;

///Intelligent Scissors


namespace ImageQuantization
{
    /// <summary>
    /// Holds the pixel color in 3 byte values: red, green and blue
    /// </summary>
    public struct RGBPixel
    {
        public byte red, green, blue;
    }
    public struct RGBPixelD
    {
        public double red, green, blue;
    }


    /// <summary>
    /// Library of static functions that deal with images
    /// </summary>
    public class ImageOperations
    {
        
        /// <summary>
        /// Display the given image on the given PictureBox object
        /// </summary>
        /// <param name="ImageMatrix">2D array that contains the image</param>
        /// <param name="PicBox">PictureBox object to display the image on it</param>
        public static void DisplayImage(RGBPixel[,] ImageMatrix, PictureBox PicBox)
        {

            // Create Image:
            //==============
            int Height = ImageMatrix.GetLength(0);
            int Width = ImageMatrix.GetLength(1);

            Bitmap ImageBMP = new Bitmap(Width, Height, PixelFormat.Format32bppArgb);

            for (int i = 0; i < Height; i++)
            {
                for (int j = 0; j < Width; j++)
                {
                    Color Pixel = Color.FromArgb(ImageMatrix[i, j].red, ImageMatrix[i, j].green, ImageMatrix[i, j].blue);
                    ImageBMP.SetPixel(j, i, Pixel);
                }
            }

            PicBox.Image = ImageBMP;

        }


        /// <summary>
        /// Get The Pixels From an Image and Write it to a Text File
        /// </summary>
        /// <param name="img"></param>
        public static RGBPixel[,] GetPixelsTo_TheFile(string imgPath)
        {

            FileStream FS = new FileStream(@"C:\Users\ibrahim\Desktop\ImagePixels2.txt", FileMode.Create);
            StreamWriter SW = new StreamWriter(FS);
            Bitmap bm = new Bitmap(imgPath);

            SW.WriteLine(bm.Width.ToString());
            SW.WriteLine(bm.Height.ToString());

            RGBPixel[,] pixelsArr = new RGBPixel[bm.Height, bm.Width];


            for (int i = 0; i < bm.Height; i++)
            {
                for (int j = 0; j < bm.Width; j++)
                {
                    Color pixel = bm.GetPixel(j, i);
                    pixelsArr[i, j].red = pixel.R;
                    pixelsArr[i, j].green = pixel.G;
                    pixelsArr[i, j].blue = pixel.B;

                    SW.WriteLine(pixel.R.ToString());
                    SW.WriteLine(pixel.B.ToString());
                    SW.WriteLine(pixel.G.ToString());

                }
            }

            SW.Close();
            MessageBox.Show("Image had Wrote to the file 2 Successfuly ");
            return pixelsArr;
        }

        
    }
}
