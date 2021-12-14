using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers;
using CSETWebCore.DataLayer;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Tests
{
    [TestClass()]
    public class DiagramManagerTests
    {
        [TestMethod()]
        public void ProcessDiagramTest()
        {
            

            DiagramManager d = new DiagramManager(new CSET_Context());
            string test = File.ReadAllText(@"TestItems\testdiagram.xml");
            //change test to reference below if wanted
            StringReader reader = new StringReader(test);
            var vertices = d.ProcessDiagramVertices(reader,2);

        }

        private static string test = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                                     "<mxGraphModel>" +
                                     "	<root>" +
                                     "		<mxCell id=\"0\"/>" +
                                     "		<mxCell id=\"1\" value=\"Main Layer\" parent=\"0\"/>" +
                                     "		<object SAL=\"Low\" label=\"Zone-1-Low\" internalLabel=\"Zone-1\" zoneType=\"Other\" zone=\"1\" id=\"2\">" +
                                     "			<mxCell style=\"swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;\" parent=\"1\" vertex=\"1\" connectable=\"0\">" +
                                     "				<mxGeometry x=\"-1542\" y=\"-1284\" width=\"562\" height=\"490\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"CNFIG-2\" ComponentGuid=\"0eecd421-65a6-4a2d-a0f3-092887a61134\" parent=\"2\" internalLabel=\"CNFIG-2\" id=\"7\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/configuration_server.svg;\" parent=\"2\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"25.84338\" y=\"67.64526\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"DCS-3\" ComponentGuid=\"b8272c3a-4615-4cdc-9fc8-57a0fa7d1b3a\" parent=\"2\" internalLabel=\"DCS-3\" id=\"8\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;\" parent=\"2\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"124.2153\" y=\"77.58569\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<mxCell id=\"Uhnw6vlZOFjEftVQ8nBR-100\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;entryX=0;entryY=0.5;entryDx=0;entryDy=0;endArrow=none;strokeColor=#808080;\" edge=\"1\" parent=\"4\" source=\"68\" target=\"69\">" +
                                     "			<mxGeometry relative=\"1\" as=\"geometry\"/>" +
                                     "		</mxCell>" +
                                     "		<object label=\"EB-66\" ComponentGuid=\"02eebd03-d432-459d-8cd1-d3d7b8b5eebf\" parent=\"4\" internalLabel=\"EB-66\" id=\"68\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/ethernet_backhaul.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"221\" y=\"64\" width=\"59\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<mxCell id=\"Uhnw6vlZOFjEftVQ8nBR-101\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;\" edge=\"1\" parent=\"4\" source=\"69\" target=\"74\">" +
                                     "			<mxGeometry relative=\"1\" as=\"geometry\"/>" +
                                     "		</mxCell>" +
                                     "		<object label=\"MS-67\" ComponentGuid=\"b5cba809-79da-4fae-b768-44884a021ffb\" parent=\"4\" internalLabel=\"MS-67\" id=\"69\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/master_site.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"324.9023\" y=\"67.45459\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"MB-68\" ComponentGuid=\"9aaebe6c-b487-423d-8f2d-42206ea1ad08\" parent=\"4\" internalLabel=\"MB-68\" id=\"70\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/microwave_backhaul.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"429.2627\" y=\"73.97717\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"RS-69\" ComponentGuid=\"e1682925-4900-43e7-b297-837fc6dc55fc\" parent=\"4\" internalLabel=\"RS-69\" id=\"71\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/radio_site.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"24.86628\" y=\"191.3826\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"RP-70\" ComponentGuid=\"61479152-e432-45bd-8ef5-7459464811f4\" parent=\"4\" internalLabel=\"RP-70\" id=\"72\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/relay_panel.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"118.7906\" y=\"199.2096\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"SubR-71\" ComponentGuid=\"2cc02b00-c224-4026-80de-a1e9dbd9a055\" parent=\"4\" internalLabel=\"SubR-71\" id=\"73\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/subscriber_radio.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"225.76\" y=\"200.514\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"T1-72\" ComponentGuid=\"ebb13174-29c8-4241-94b2-9723f5ae5843\" parent=\"4\" internalLabel=\"T1-72\" id=\"74\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/t1_backhaul.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"326.2068\" y=\"196.6006\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"TDM-73\" ComponentGuid=\"50e06c21-b081-445d-b636-9ead315a104a\" parent=\"4\" internalLabel=\"TDM-73\" id=\"75\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/tdm_backhaul.svg;\" parent=\"4\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"425.3492\" y=\"210.9501\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object SAL=\"Low\" label=\"Zone-74-Low\" internalLabel=\"Zone-74\" zoneType=\"Other\" zone=\"1\" id=\"5\">" +
                                     "			<mxCell style=\"swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;\" parent=\"1\" vertex=\"1\" connectable=\"0\">" +
                                     "				<mxGeometry x=\"489\" y=\"-1284\" width=\"629\" height=\"544\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<mxCell id=\"Uhnw6vlZOFjEftVQ8nBR-103\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;\" edge=\"1\" parent=\"5\" source=\"76\" target=\"77\">" +
                                     "			<mxGeometry relative=\"1\" as=\"geometry\"/>" +
                                     "		</mxCell>" +
                                     "		<object label=\"CT-75\" ComponentGuid=\"fe1d34c7-174f-4bd3-84f0-322712ccd7fe\" parent=\"5\" internalLabel=\"CT-75\" id=\"76\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/ct_scanner.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"23.16876\" y=\"55.62756\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"ECG-76\" ComponentGuid=\"8cffa4fa-cc42-4a43-bb7e-69bd5ad7316b\" parent=\"5\" internalLabel=\"ECG-76\" id=\"77\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/ecg.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"122.3112\" y=\"55.62756\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"EEG-77\" ComponentGuid=\"751320a9-6195-42c2-a620-bfabfbdb6fe2\" parent=\"5\" internalLabel=\"EEG-77\" id=\"78\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/eeg.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"213.6265\" y=\"58.23657\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"EMG-78\" ComponentGuid=\"f174e595-e611-4a86-a539-d0a669e00fb9\" parent=\"5\" internalLabel=\"EMG-78\" id=\"79\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/emg.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"317.9869\" y=\"59.54114\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"EMS-79\" ComponentGuid=\"d9dd74dc-89ad-41a4-971a-a52d56ec1af5\" parent=\"5\" internalLabel=\"EMS-79\" id=\"80\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/emergency_medical_service_communications_hardware.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"410.6067\" y=\"62.15015\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"Endo-80\" ComponentGuid=\"4aa14128-228c-4b2d-88c4-0684ce243709\" parent=\"5\" internalLabel=\"Endo-80\" id=\"81\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/endoscopy_system.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"516.2715\" y=\"64.75916\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"IMG-81\" ComponentGuid=\"3a75cbd0-cc86-4d7d-b2f6-7ecb238929b6\" parent=\"5\" internalLabel=\"IMG-81\" id=\"82\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/imaging_server.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"23.16876\" y=\"182.1646\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"IME-82\" ComponentGuid=\"c4f34852-b25c-4737-bb4c-2542f6b852a0\" parent=\"5\" internalLabel=\"IME-82\" id=\"83\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/imaging_modalities_and_equipment.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"117.0931\" y=\"188.687\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"IVPMP-83\" ComponentGuid=\"34f8e8ce-0c73-4d2f-a0ef-f8fef9d50caf\" parent=\"5\" internalLabel=\"IVPMP-83\" id=\"84\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/infusion_pump.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"205.7994\" y=\"193.905\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"IVPMP-84\" ComponentGuid=\"2d011ca1-c528-42c0-9178-2d7683fab25d\" parent=\"5\" internalLabel=\"IVPMP-84\" id=\"85\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/infusion_pump.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"307.5508\" y=\"196.514\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"Linac-85\" ComponentGuid=\"be076d6c-4b17-400b-9f54-b5c50480838f\" parent=\"5\" internalLabel=\"Linac-85\" id=\"86\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/linear_partical_accelerator.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"402.7797\" y=\"188.687\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"MPGSS-86\" ComponentGuid=\"7d2f1aef-628f-4a68-8bee-e6c5044e8293\" parent=\"5\" internalLabel=\"MPGSS-86\" id=\"87\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/medical_gas_system.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"500.6175\" y=\"189.9916\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"PMD-87\" ComponentGuid=\"509b8341-1e0f-432f-8919-d22a06e4acc4\" parent=\"5\" internalLabel=\"PMD-87\" id=\"88\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"28.38678\" y=\"308.7015\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"MRI-88\" ComponentGuid=\"98267ddc-0058-4c75-b0f1-c2206fe71054\" parent=\"5\" internalLabel=\"MRI-88\" id=\"89\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/magnetic_resonance_imaging.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"118.3976\" y=\"311.3105\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"IPRDU-89\" ComponentGuid=\"6a75a243-1a0e-4298-9773-f9316b03aa8e\" parent=\"5\" internalLabel=\"IPRDU-89\" id=\"90\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/infant_protection_remote_display_unit.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"213.6265\" y=\"320.442\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"RTLS-90\" ComponentGuid=\"3ce3440a-81fa-444f-ad81-fe1b51345afa\" parent=\"5\" internalLabel=\"RTLS-90\" id=\"91\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/real_time_location_system.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"315.3779\" y=\"317.833\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"US-91\" ComponentGuid=\"0023c3fa-582e-4257-9e05-250b51e80260\" parent=\"5\" internalLabel=\"US-91\" id=\"92\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/ultrasound.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"411.9112\" y=\"320.442\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"UDE-92\" ComponentGuid=\"64832d85-2f89-456a-9d95-2b80b439bbe4\" parent=\"5\" internalLabel=\"UDE-92\" id=\"93\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/urodynamic_diagnostic_equipment.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"512.358\" y=\"311.3105\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"XRay-93\" ComponentGuid=\"bb92c750-38ab-4b3d-97a0-b78c3773e7a3\" parent=\"5\" internalLabel=\"XRay-93\" id=\"94\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/xray_generator.svg;\" parent=\"5\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"34.9093\" y=\"428.7159\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object SAL=\"Low\" label=\"Zone-94-Low\" internalLabel=\"Zone-94\" zoneType=\"Other\" zone=\"1\" id=\"6\">" +
                                     "			<mxCell style=\"swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;\" parent=\"1\" vertex=\"1\" connectable=\"0\">" +
                                     "				<mxGeometry x=\"1158\" y=\"-1280\" width=\"790\" height=\"199\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"CON-95\" ComponentGuid=\"d6543f0b-e8d7-4783-9b73-1c28543d8d02\" parent=\"6\" internalLabel=\"CON-95\" id=\"95\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;\" parent=\"6\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"38.35046\" y=\"62.58252\" width=\"78\" height=\"58\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"PA-96\" ComponentGuid=\"9dfea05d-3cd7-4ef6-b274-e32847452e20\" parent=\"6\" internalLabel=\"PA-96\" id=\"96\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/partner.svg;\" parent=\"6\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"148.7145\" y=\"52.93213\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"UN-97\" ComponentGuid=\"53968a70-cd45-4f5b-8b1a-b1edc0f4cfcc\" parent=\"6\" internalLabel=\"UN-97\" id=\"97\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;\" parent=\"6\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"251.7703\" y=\"56.84558\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"VE-98\" ComponentGuid=\"919f62c7-e979-4e11-8c21-4ca35b23b34c\" parent=\"6\" internalLabel=\"VE-98\" id=\"98\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/vendor.svg;\" parent=\"6\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"350.9126\" y=\"56.84558\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<object label=\"WEB-99\" ComponentGuid=\"aa60e602-54cf-4d5b-8f4f-ca1ed45ae1cd\" parent=\"6\" internalLabel=\"WEB-99\" id=\"99\">" +
                                     "			<mxCell style=\"whiteSpace=wrap;html=1;image;image=img/cset/web.svg;\" parent=\"6\" vertex=\"1\">" +
                                     "				<mxGeometry x=\"447.446\" y=\"60.75916\" width=\"60\" height=\"60\" as=\"geometry\"/>" +
                                     "			</mxCell>" +
                                     "		</object>" +
                                     "		<mxCell id=\"Uhnw6vlZOFjEftVQ8nBR-102\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;\" edge=\"1\" parent=\"1\" source=\"70\" target=\"76\">" +
                                     "			<mxGeometry relative=\"1\" as=\"geometry\"/>" +
                                     "		</mxCell>" +
                                     "		<mxCell id=\"Uhnw6vlZOFjEftVQ8nBR-104\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;endArrow=none;strokeColor=#808080;\" edge=\"1\" parent=\"1\" source=\"100\" target=\"20\">" +
                                     "			<mxGeometry relative=\"1\" as=\"geometry\"/>" +
                                     "		</mxCell>" +
                                     "	</root>" +
                                     "</mxGraphModel>";
    }
}