using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PlanillaObrera1
{
	public partial class Login : System.Web.UI.Page
	{
		public static SqlConnection sqlConNaty = new SqlConnection("Data Source=DESKTOP-SV37236\\NATALIASQL;Initial Catalog=PlanillaObrera;Persist Security Info=True;User ID=sa;Password=naty0409;MultipleActiveResultSets=True;Application Name=EntityFramework");
		public static SqlConnection sqlConFeng = new SqlConnection(ConfigurationManager.ConnectionStrings["f3n9laptop"].ToString());
		public static SqlConnection sqlCon = sqlConFeng;
		protected void Page_Load(object sender, EventArgs e)
		{
		}

		protected void loginBtn_Click(object sender, EventArgs e)
		{
			String usernameGot, passGot;
			usernameGot = usernameText.Text;
			passGot = passwordText.Text;
			if (usernameGot.Length != 0 && passGot.Length != 0)
			{
				if (sqlCon.State == ConnectionState.Closed)
					sqlCon.Open();
				SqlCommand sqlCom = new SqlCommand("spLogin", sqlCon);
				sqlCom.CommandType = CommandType.StoredProcedure;
				sqlCom.Parameters.AddWithValue("@username", usernameGot);
				sqlCom.Parameters.AddWithValue("@password",passGot);
				sqlCom.Parameters.Add("@accepted", SqlDbType.Int);
				sqlCom.Parameters["@accepted"].Direction = ParameterDirection.Output;
				sqlCom.ExecuteNonQuery();

				int accepted =(int)sqlCom.Parameters["@accepted"].Value;
				sqlCon.Close();

				Debug.WriteLine(accepted.ToString());
				Session["user"] = usernameGot;
				Session["connectionString"] = sqlCon;
				switch (accepted)
				{
					case 0:
						MessageBox.Show("Usuario no existe.");
						break;
					case 1:
						Response.Redirect("Jefe.aspx");
						break;
					case 2:
						Response.Redirect("Obrero.aspx");
						break;
				}
			}
			else
			{
				MessageBox.Show("HAY CAMPOS VACIOS!");
			}
		}
	}
}