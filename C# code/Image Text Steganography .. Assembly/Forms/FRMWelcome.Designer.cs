namespace Image_Text_Steganography_._Assembly.Forms
{
    partial class FRMWelcome
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.HideImgBtn = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(336, 52);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(182, 33);
            this.button1.TabIndex = 0;
            this.button1.Text = "Retreive Text From An Image";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // HideImgBtn
            // 
            this.HideImgBtn.Location = new System.Drawing.Point(32, 52);
            this.HideImgBtn.Name = "HideImgBtn";
            this.HideImgBtn.Size = new System.Drawing.Size(182, 33);
            this.HideImgBtn.TabIndex = 1;
            this.HideImgBtn.Text = "Hide Text Inside Image";
            this.HideImgBtn.UseVisualStyleBackColor = true;
            this.HideImgBtn.Click += new System.EventHandler(this.HideImgBtn_Click);
            // 
            // FRMWelcome
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(573, 116);
            this.Controls.Add(this.HideImgBtn);
            this.Controls.Add(this.button1);
            this.Name = "FRMWelcome";
            this.Text = "FRMWelcome";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button HideImgBtn;
    }
}