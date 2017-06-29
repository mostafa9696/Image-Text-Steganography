using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace Image_Text_Steganography_._Assembly
{
    class Assembly_Executer_DLL
    {
        /// <summary>
        /// Fills The Buffer In The Assembly File With Pixels
        /// </summary>
        /// <param name="imgpath"></param>
        /// <returns></returns>
        [DllImport("Project.dll")]
        public static extern int FillBuffer([In] string imgpath);

        

    }
}
