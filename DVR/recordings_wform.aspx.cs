using System;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Threading;
using System.ComponentModel;

public partial class DVR_recordings : System.Web.UI.Page
{
    
    //protected void Page_Load(object sender, EventArgs e)
    //{
    //    lblMsg.Text = string.Empty;
    //}

    protected void btnEmail_Click(object sender, System.EventArgs e)
    {
                
        MailMessage lEmail = new MailMessage();
        
        //Fields
        lEmail.From = new MailAddress(txtFrom.Text);
        lEmail.To.Add(new MailAddress(txtTo.Text));
        lEmail.Subject = "REVIEW: Video Clip";
        lEmail.Body = txtBody.Text + "<p>" + clipUrl.Value;
        lEmail.IsBodyHtml = true;
        lEmail.Priority = MailPriority.Normal;

        //Send Email
        SmtpClient myClient = new SmtpClient();
        try
        {
            myClient.Send(lEmail);
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error sending email:" + ex.ToString();
            lblMsg.Visible = true;
        }
    }
}