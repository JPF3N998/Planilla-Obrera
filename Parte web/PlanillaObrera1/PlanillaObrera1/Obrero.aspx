<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Obrero.aspx.cs" Inherits="PlanillaObrera1.Obrero" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Obrero</title>
</head>
<body>
    <form id="form1" runat="server"  style ="background-color:#173e43;font-family:Bahnschrift;font-size:40px; height:auto;">
        <asp:Label ID="DocIdLabel" runat="server" Text="Numero de documento: " ForeColor="White"></asp:Label>
        <asp:Label ID="DocIdValue" runat="server" Text="DefaultText" ForeColor="White"></asp:Label>
        <br />
        <asp:GridView ID="gridMensuales" runat="server" align="Center" ForeColor="Black" Visible="False" BackColor="#3FB0AC" BorderWidth="2px" CellPadding="1" CellSpacing="1" Font-Size="20px" HorizontalAlign="Center"></asp:GridView>
        <br />
        <asp:GridView ID="gridSemanales" runat="server" align="Center" ForeColor="Black" Visible="False" BackColor="#3FB0AC" BorderWidth="2px" CellPadding="1" CellSpacing="1" Font-Size="20px" HorizontalAlign="Center"></asp:GridView>
        <br />
        <asp:GridView ID="gridMovimientos" runat="server" align="Center" ForeColor="Black" Visible="False" BackColor="#3FB0AC" BorderWidth="2px" CellPadding="1" CellSpacing="1" Font-Size="20px" HorizontalAlign="Center"></asp:GridView>
    </form>
</body>
</html>

