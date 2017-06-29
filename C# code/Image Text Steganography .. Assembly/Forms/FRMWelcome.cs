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
    public partial class FRMWelcome : Form
    {
        public FRMWelcome()
        {
            InitializeComponent();
        }

        private void HideImgBtn_Click(object sender, EventArgs e)
        {
            FRMHide frmHide = new FRMHide();
            frmHide.ShowDialog();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FRMRetreiveText RetText = new FRMRetreiveText();
            RetText.ShowDialog();
        }
    }
}
