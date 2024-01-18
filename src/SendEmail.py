import smtplib, ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os
import datetime
from email import encoders
from email.mime.base import MIMEBase


class SendEmail():

    def send_report_email(self, filename, pass_, fail, status, colour):

        receiver_address = ["craig.jones@rheem.com", "elizaveta.burdaeva@orioninc.com",
                            "garvish.raval@volansys.com", "vyom.joshi@volansys.com", "ritesh.gajjar@volansys.com",
                            "akshay.suthar@volansys.com", "jignesh.parekh@volansys.com"]

        # receiver_address = ["akshay.suthar@volansys.com"]

        print("Sending Email...")
        curr_dir = os.getcwd()
        message = MIMEMultipart()
        message['From'] = "rheemautomation@gmail.com"
        message['To'] = ", ".join(receiver_address)
        message['Subject'] = "Rheem Econet Reskin Automation Smoke Report of Test Environment Release " + str(
            datetime.datetime.now().strftime(
                "%Y%m%d-%H:%M")) + " with iOS App. Bitrise Build Number #7021 [v6.0.4 (7021)]"
        mail_content = """\
        <html>
          <body>
            <p>Hi,<br><br>
               Please find an automated Smoke test report for the iOS Econet Reskin Application attached.<br>
            </p>
            <table style="border:1px solid black; width:20%;text-align: center;">
            <tr style="border:1px solid black">
            <th style="border:1px solid black;">Status </th>
            <th style="border:1px solid black;background-color:{colour};">{status}</th>
            </table>
            <br>
            <table style="border:1px solid black; width:40%;text-align: left;">
          <tr style="border:1px solid black">
            <th style="border:1px solid black;">Release Version &nbsp;  </th>
            <th style="border:1px solid black">v6.0.5(7021)</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Device  </th>
            <th style="border:1px solid black">iPhone 12mini  </th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">iOS Version</th>
            <th style="border:1px solid black">14.6</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Cloud Version  </th>
            <th style="border:1px solid black">4.3.7.0</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Environment</th>
            <th style="border:1px solid black">Test</th>
          </tr>
        </table><br>
           <table>
           <tr>
            <th>Smoke Execution Status :</th>
          </tr>
           </table>
            <table style="border:1px solid black; width:40%;text-align: center;">
          <tr style="border:1px solid black">
            <th style="border:1px solid black; background-color:MediumSeaGreen;">PASS</th>
            <th style="border:1px solid black;background-color:Tomato">FAIL</th>
            <th style="border:1px solid black; background-color:LightGray;">TOTAL  </th>
          </tr>
          <tr style="border:1px solid black">
            <td style="border:1px solid black">{Pass}</td>
            <td style="border:1px solid black">{Fail}</td>
            <td style="border:1px solid black">{Total}</td>
          </tr>
        </table><br>
         <p font-weight: bold;>
               Testrail Link: https://rheem.testrail.io/index.php?/runs/view/{run_id}.<br><br>
               <p>
                <b>Note:</b>
                <ul>
                <li> If any test is getting fail will mark the entire execution status as “Off Track”. </li>
                <li> Detailed reports are attached in Zip File. </li>
                </ul>
                Please let us know if you need more information from our end.<br>
         </p>
          </body>
        </html>
        """.format(Pass=pass_, Fail=fail, Total=int(pass_) + int(fail), status=status, colour=colour,
                   run_id="13110")
        message.attach(MIMEText(mail_content, 'html'))
        zip_name = self.create_zip_file(filename)
        attachment = open(zip_name, "rb")

        p = MIMEBase('application', 'octet-stream')
        p.set_payload((attachment).read())
        encoders.encode_base64(p)
        p.add_header('Content-Disposition', 'attachment', filename=zip_name)
        message.attach(p)
        attachment.close()

        try:
            s = smtplib.SMTP('smtp.gmail.com', 587)
            s.starttls()
            s.login("rheemautomation@gmail.com", "wgcucwqxuxhziyeu")
            text = message.as_string()
            s.sendmail("rheemautomation@gmail.com", receiver_address, text)
            s.quit()
            os.chdir(curr_dir)
            print("Email sent successfully..")
            # terminating the session for the execution.
        except Exception as e:
            print("exception : ", e)

