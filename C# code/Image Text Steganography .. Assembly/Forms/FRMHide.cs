using ImageQuantization;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Image_Text_Steganography_._Assembly.Forms
{
    public partial class FRMHide : Form
    {
        RGBPixel[,] ImageMatrix;

        public FRMHide()
        {
            InitializeComponent();
        }

        private void btnOpen_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            string OpenedFilePath;
            int indicator = 1;
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                //Open the browsed image and Write it to The File and display it
                OpenedFilePath = openFileDialog1.FileName;
                ImageMatrix = ImageOperations.GetPixelsTo_TheFile(OpenedFilePath);
                ImageOperations.DisplayImage(ImageMatrix, pictureBox1);

                try
                {
                    // Fill The Buffer Into The Assembly File
                    indicator = Image_Text_Steganography_._Assembly.Assembly_Executer_DLL.FillBuffer(OpenedFilePath);
                    if (indicator == 0)
                        MessageBox.Show("Buffer Filled Successfully");
                    else
                        MessageBox.Show("Buffer DID NOT Filled Successfully", "WRONG", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message.ToString());
                }


            }
            txtWidth.Text = ImageMatrix.GetLength(0).ToString();
            txtHeight.Text = ImageMatrix.GetLength(1).ToString();


            // ImageOperations.DisplayImage(ImageMatrix, pictureBox2);
        }
    }
}
