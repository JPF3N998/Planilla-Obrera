using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace PlanillaObrera1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
		public static SqlConnection sqlConNaty = new SqlConnection("Data Source=DESKTOP-SV37236\\NATALIASQL;Initial Catalog=PlanillaObrera;Persist Security Info=True;User ID=sa;Password=naty0409;MultipleActiveResultSets=True;Application Name=EntityFramework");
		public static SqlConnection sqlConFeng = new SqlConnection("Data Source=F3N9-ASUS;Initial Catalog=PlanillaObrera;Integrated Security=True");
		public static SqlConnection sqlCon = sqlConFeng;
		protected void Page_Load(object sender, EventArgs e)
        {
            txtValor.Visible = false;
            Label1.Visible = false;
            btnOK.Visible = false;
            lblSuccessMessage.Visible = false;
            VerSalalarioXHora();
        }

        void VerSalalarioXHora()
        {
            if (sqlCon.State == ConnectionState.Closed)
                sqlCon.Open();
            SqlDataAdapter sqlDa = new SqlDataAdapter("spVerSalarioXHora", sqlCon);
            sqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
            DataTable dtbl = new DataTable();
            sqlDa.Fill(dtbl);
            sqlCon.Close();
            gvSalarioXHora.DataSource = dtbl;
            gvSalarioXHora.DataBind();
        }

        protected void lnk_OnClick(object sender, EventArgs e)
        {
            txtValor.Visible = true;
            Label1.Visible = true;
            btnOK.Visible = true;
            int id = Convert.ToInt32((sender as LinkButton).CommandArgument);
            if (sqlCon.State == ConnectionState.Closed)
                sqlCon.Open();
            SqlDataAdapter sqlDa = new SqlDataAdapter("spVerSalarioXHoraID", sqlCon);
            sqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
            sqlDa.SelectCommand.Parameters.AddWithValue("id", id);
            DataTable dtbl = new DataTable();
            sqlDa.Fill(dtbl);
            sqlCon.Close();
            hfid.Value = id.ToString();
            txtValor.Text = dtbl.Rows[0]["valorHora"].ToString();
        }


        protected void btnOK_Click(object sender, EventArgs e)
        {
            if (sqlCon.State == ConnectionState.Closed)
                sqlCon.Open();
            SqlCommand sqlCmd = new SqlCommand("spEditarSalarioXHora", sqlCon);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.AddWithValue("@id", (hfid.Value == "" ? 0 : Convert.ToInt32(hfid.Value)));
            sqlCmd.Parameters.AddWithValue("@valor", txtValor.Text.Trim());
            sqlCmd.ExecuteNonQuery();
            sqlCon.Close();
            string contactID = hfid.Value;
            lblSuccessMessage.Visible = true;
            VerSalalarioXHora();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Jefe.aspx");
        }
    }
}