<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PlanillaObrera1.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="width: inherit;background-color:#173e43; height: 368px;">
    <form id="form1" runat="server">
    <p style="font-family: Bahnschrift; font-size: 50px; font-weight: bold; color: #FFFFFF;text-align:center">
        LOGIN</p>
    <center style="font-family:Bahnschrift;font-size:40px;color:#FFFFFF">
        <div>
                <asp:Panel ID="Panel1" runat="server" Wrap="true" Height="287px">
                    Username <asp:TextBox ID="usernameText" runat="server" BorderColor="#3FB0AC" BorderStyle="Solid" BorderWidth="2px"></asp:TextBox>
                    <br />
                    Password <asp:TextBox ID="passwordText" runat="server" BorderColor="#3FB0AC" BorderStyle="Solid" BorderWidth="2px" TextMode="Password"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Button ID="loginBtn" runat="server" Text="Login" BackColor="#FAE596" BorderColor="#3FB0AC" BorderStyle="Solid" BorderWidth="10px" Font-Bold="True" Font-Names="Bahnschrift" Font-Size="XX-Large" ForeColor="Black" OnClick="loginBtn_Click"/>
                    <br />
                    <br />
                </asp:Panel>
    </center>
        

    </div>
    </form>
</body>
</html>
