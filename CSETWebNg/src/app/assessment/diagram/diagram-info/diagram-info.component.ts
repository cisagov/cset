////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Location } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { AuthenticationService } from '../../../services/authentication.service';
import { HydroService } from '../../../services/hydro.service';
import { MatDialog } from '@angular/material/dialog';
import { MalcolmUploadErrorComponent } from '../../../dialogs/malcolm/malcolm-upload-error.component';
import { ConfigService } from '../../../services/config.service';
import { NavTreeNode, NavigationService } from '../../../services/navigation/navigation.service';
import { MalcolmService } from '../../../services/malcolm.service';
import { MalcolmInstructionsComponent } from '../../../dialogs/malcolm/malcolm-instructions/malcolm-instructions.component';

@Component({
    selector: 'app-info',
    templateUrl: './diagram-info.component.html'
})
export class DiagramInfoComponent implements OnInit {

    msgDiagramExists = 'Edit the Network Diagram';
    msgNoDiagramExists = 'Create a Network Diagram';
    buttonText: string = this.msgNoDiagramExists;
    hasDiagram: boolean = false;

    malcolmFiles: File[];


    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public configSvc: ConfigService,
        public authSvc: AuthenticationService,
        public hydroSvc: HydroService,
        public malcolmSvc: MalcolmService,
        private location: Location,
        private dialog: MatDialog,
    ) { }
    tree: NavTreeNode[] = [];
    ngOnInit() {
        //this.populateTree();
        this.checkForDiagram();

        // When returning from Diagram, we get a brand new authSvc.
        // This refreshes the isLocal flag.
        if (this.authSvc.isLocal === undefined) {
            this.authSvc.checkLocalInstallStatus().subscribe((resp: boolean) => {
                this.authSvc.isLocal = resp;
            });
        }
        this.delayCheckForDiagram(1000);
    }

    populateTree() {
        this.navSvc.buildTree();
    }

    private checkForDiagram() {
        this.assessSvc.hasDiagram().subscribe((resp: boolean) => {
            this.hasDiagram = resp;
            this.buttonText = this.hasDiagram ? this.msgDiagramExists : this.msgNoDiagramExists;
        });
    }

    private async delayCheckForDiagram(ms) {
        await this.delay(ms)
        this.checkForDiagram();
    }

    private delay(ms: number) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    navToDiagram(which: string) {
        const jwt = localStorage.getItem('userToken');
        const apiUrl = this.configSvc.apiUrl;
        let host = this.configSvc.apiUrl;
        if (host.endsWith('/api/')) {
            host = host.substr(0, host.length - 4);
        }

        let client;
        if (window.location.protocol === 'file:') {
            client = window.location.href.substring(0, window.location.href.lastIndexOf('/dist') + 5);
        } else {
            client = window.location.origin;
        }

        let folder = 'diagram';
        if (which == 'orig') {
            folder = 'diagram-orig'
        }

        window.location.href = host + folder + '/src/main/webapp/index.html' +
            '?j=' + jwt +
            '&h=' + apiUrl +
            '&c=' + client +
            '&l=' + this.authSvc.isLocal +
            '&a=' + localStorage.getItem('assessmentId');
    }

    uploadMalcolmData(event: any) {
        this.malcolmFiles = event.target.files;

        if (this.malcolmFiles) {
            this.hydroSvc.uploadMalcolmFiles(this.malcolmFiles).subscribe(
                (result) => {
                    if (result != null) {
                        this.openUploadErrorDialog(result);
                    } else {
                        location.reload();
                    }
                });
        }
    }

    openUploadErrorDialog(errorData: any) {
        let errorDialog = this.dialog.open(MalcolmUploadErrorComponent, {
            minHeight: '300px',
            minWidth: '400px',
            data: {
                error: errorData
            }
        });
    }

    openMalcolmInstructionsDialog() {
        let instructionDialog = this.dialog.open(MalcolmInstructionsComponent, {
            minHeight: '300px',
            minWidth: '400px'
        });
    }

}
