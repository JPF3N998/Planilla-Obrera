using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace PlanillaObrera1
{
    public partial class Obrero : Page
    {
		public static SqlConnection sqlConNaty = new SqlConnection("Data Source=DESKTOP-SV37236\\NATALIASQL;Initial Catalog=PlanillaObrera;Persist Security Info=True;User ID=sa;Password=naty0409;MultipleActiveResultSets=True;Application Name=EntityFramework");
		public static SqlConnection sqlConFeng = new SqlConnection(ConfigurationManager.ConnectionStrings["f3n9laptop"].ToString());
		public static SqlConnection sqlCon = sqlConFeng;
		protected void Page_Load(object sender, EventArgs e)
        {
			this.DocIdValue.Text = Session["user"].ToString();
			if (sqlCon.State == ConnectionState.Closed)
				sqlCon.Open();
			DataTable planillasMensuales = new DataTable();
			DataTable planillasSemanales = new DataTable();
			DataTable tablaMovimientos = new DataTable();

			SqlDataAdapter sqlDa = new SqlDataAdapter("spVerPlanillasSemanales", sqlCon);
			sqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
			sqlDa.SelectCommand.Parameters.AddWithValue("@DocIdParam", Session["user"].ToString());
			sqlDa.SelectCommand.Parameters.AddWithValue("@idPlanillaSemanal", 0);

			SqlDataAdapter sqlDa2 = new SqlDataAdapter("spVerPlanillasMensuales", sqlCon);
			sqlDa2.SelectCommand.CommandType = CommandType.StoredProcedure;
			sqlDa2.SelectCommand.Parameters.AddWithValue("@DocIdParam",Session["user"].ToString());

			SqlDataAdapter sqlDa3 = new SqlDataAdapter("spVerMovimientos", sqlCon);
			sqlDa3.SelectCommand.CommandType = CommandType.StoredProcedure;
			sqlDa3.SelectCommand.Parameters.AddWithValue("@DocIdParam",Session["user"].ToString());
			sqlDa3.SelectCommand.Parameters.AddWithValue("@idPlanillaSemanal",0);

			sqlDa.Fill(planillasSemanales);
			sqlDa2.Fill(planillasMensuales);
			sqlDa3.Fill(tablaMovimientos);

			this.gridMensuales.DataSource = planillasMensuales;
			this.gridMensuales.DataBind();
			this.gridMensuales.Visible = true;

			this.gridSemanales.DataSource = planillasSemanales;
			this.gridSemanales.DataBind();
			this.gridSemanales.Visible = true;

			this.gridMovimientos.DataSource = tablaMovimientos;
			this.gridMovimientos.DataBind();
			this.gridMovimientos.Visible = true;

			sqlCon.Close();
		}

		protected void submitBtn_Click(object sender, EventArgs e)
		{
			String valueGot = this.valueText.Text;
			if(valueGot.Length == 0)
			{
				MessageBox.Show("Valor invalido.");
			}
			else if(this.RadioButtonList1.SelectedIndex == 0) // Busqueda por planilla mensual
			{
				
			}
		}
	}
}