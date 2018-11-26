<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditarValor.aspx.cs" Inherits="PlanillaObrera1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <h2 align="center">Editar Valor por Hora</h2>
</head>
<body bgcolor="#e5e8e7">
    <form id="form1" runat="server" align="center">
        <div aria-orientation="horizontal">
            <asp:HiddenField ID="hfid" runat="server" />
            <table align="center">n
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Valor:" Font-Names="Century Gothic"></asp:Label>
                </td>
                <td colspan="2">
                    <asp:TextBox ID="txtValor" runat="server" Font-Names="Century Gothic"></asp:TextBox>
                </td>
            </tr>
                <tr>
                    <td></td>
                    <td colspan="2">
                        <asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" Font-Names="Century Gothic"/>
                    </td>
                    <td colspan="2">
                    <asp:Label ID="lblSuccessMessage" runat="server" Text="Se ha cambiado el monto" ForeColor="Green"></asp:Label>
                    </td>
                </tr>
            </table>
            <asp:GridView ID="gvSalarioXHora" runat="server" AutoGenerateColumns="false" bgcolor="#bedae5" Font-Names="Century Gothic" align="center">
                <Columns>
                    <asp:BoundField DataField="idPuesto" HeaderText="idPuesto" />
                    <asp:BoundField DataField="idTipoJornada" HeaderText="idTipoJornada" />
                    <asp:BoundField DataField="valorHora" HeaderText="valorHora" />
                    <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEditar" runat="server" CommandArgument='<%# Eval("id") %>' OnClick="lnk_OnClick">Editar</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <table align="left">
            <asp:Button ID="Button1" runat="server" Font-Bold="True" Font-Names="Century Gothic" Font-Size="Medium" Height="46px" OnClick="Button1_Click" Text="Volver" Width="125px" align="left" />
        </table>
    </form>
</body>
</html>