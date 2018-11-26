<%@ Page Title="Jefe" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Jefe.aspx.cs" Inherits="PlanillaObrera1.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <asp:Button ID="Button1" runat="server" Height="76px" OnClick="Button1_Click" Text="Editar Valor por hora" Width="261px" BackColor="#d6a368" Font-Bold="True" Font-Size="Medium" ForeColor="Black" />
    <asp:Button ID="EditarDeducciones" runat="server" Height="76px" OnClick="Button2_Click" Text="Editar Deducciones" Width="261px" BackColor="#d6a368" Font-Bold="True" Font-Size="Medium" ForeColor="Black" />
    <asp:Button ID="EditarBonos" runat="server" Height="76px" OnClick="Button3_Click" Text="Editar Bonos" Width="261px" BackColor="#d6a368" Font-Bold="True" Font-Size="Medium" ForeColor="Black" />
</asp:Content>
