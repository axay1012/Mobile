def email_format():
    return """\
        <html>
          <body>
            <p>Hi,<br><br>
               Please find the HTPG Portal Automation Execution Status report below, along with the appropriate details.
<br>
            </p>
            <br>
            <table style="border:1px solid black; width:40%;text-align: left;">
            <tr style="border:1px solid black">
            <th style="border:1px solid black; background-color:LightGray;text-align: center">Details &nbsp;  </th>
            <th style="border:1px solid black; background-color:LightGray;text-align: center">Value</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black;">Environment &nbsp;  </th>
            <th style="border:1px solid black">Staging</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">HTPG Portal Version  </th>
            <th style="border:1px solid black">1.1.30.0</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">RheemConnect Cloud Version</th>
            <th style="border:1px solid black">4.3.11.0</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Browser</th>
            <th style="border:1px solid black">Chrome</th>
          </tr>
          <tr style="border:1px solid black">
            <th style="border:1px solid black">Total Features</th>
            <th style="border:1px solid black">25</th>
          </tr>
        </table><br>
           <table>
           <tr>
            <th>HTPG Execution Status :</th>
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
                If you have any questions or queries, please feel free to let us know.<br>
         </p>
         <p>
                Thanks & Regards<br>
          </body>
        </html>
        """