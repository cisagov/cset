# Using the CSET Stand-alone Installer

The installer will add everything needed to run CSET on a self-contained Windows computer.

## Install Process
Double-click on the CSETStandAlone program.

The User Account Control dialog will appear (Fig.1). Select &quot;Yes&quot;.

![User account control dialog][fig1]

**Figure 1: User Account Control Box**

A CSET dialog will open asking if you want to install the CSET Desktop (Fig.2). Select &quot;Yes&quot;.

![Install dialog][fig2]

**Figure 2: Install Dialog**

The program will begin extracting.

After the extraction is finished, a CSET Setup dialog will open (Fig.3). Select &quot;Install&quot;.

![CSET setup dialog][fig3]

**Figure 3. CSET Setup**

CSET will begin to install. If the user doesn&#39;t have SQL Server 2022 LocalDB, CSET will install it. The SQL Server 2022 LocalDB Setup dialog will open (Fig.4). Click the check box to confirm that you &quot;…accept the terms in the License Agreement&quot;, select &quot;Next&quot;, and then select &quot;Install&quot;.

![LocalDB 2022 setup dialog][fig4]
 
**Figure 4. LocalDB 2022 Setup**

LocalDB 2022 will install. Select &quot;Finish&quot; when it completes.

CSET will also install the .NET 7 and ASP.NET Core 7 runtimes in the background if they are not already installed.

The CSET Setup Wizard will open to walk the user through the install process (Fig.5). Select &quot;Next&quot;.

![Setup wizard dialog][fig5]

**Figure 5: Setup Wizard**

A disclaimer will open (Fig.6). Read through and then click the box &quot;I read the disclaimer&quot;, and select &quot;Next&quot;.

![Disclaimer dialog][fig6]
 
**Figure 6: Disclaimer**

CSET will choose a default folder to install CSET to, but you can change this in the Destination Folder dialog (Fig.7). Select &quot;Next&quot;.

![Install destination dialog][fig7]
 
**Figure 7: Destination Folder**

The CSET Installer will show that it is ready to install (Fig. 8). Select &quot;Install&quot;.

![Ready to install dialog][fig8]
 
**Figure 8: Ready to Install**

The installation of the main CSET application will begin. Once the installation is finished, the completed CSET Setup Wizard dialog will appear. Make sure the &quot;Launch CSET when setup exists&quot; box is checked, and select &quot;Finish&quot;.

![Completed CSET setup wizard dialog][fig9]
 
**Figure 9: Completed CSET Setup Wizard**

The user should see a setup successful dialog (Fig.10).

![Setup successful dialog][fig10]
 
**Figure 10: Setup Successful**

The user has access to CSET as Local User. The Local Installation ribbon is visible at the top of the screen. They can see their landing page with no assessments at this time (Fig.11).

![Local install landing page][fig11]

Figure 11: Local Install Landing Page

[fig1]: img/fig1.png
[fig2]: img/fig2.png
[fig3]: img/fig3.png
[fig4]: img/fig4.png
[fig5]: img/fig5.png
[fig6]: img/fig6.png
[fig7]: img/fig7.png
[fig8]: img/fig8.png
[fig9]: img/fig9.png
[fig10]: img/fig10.png
[fig11]: img/fig11.png

<style>
img { width: 60% }
</style>