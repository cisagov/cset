////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { NavigationService } from '../../../services/navigation.service';
import { NavTreeNode } from '../../../services/navigation.service';
import { ConfigService } from '../../../services/config.service';
import { Location } from '@angular/common';
import { AuthenticationService } from '../../../services/authentication.service';

@Component({
    selector: 'app-info',
    templateUrl: './diagram-info.component.html'
})
export class DiagramInfoComponent implements OnInit {

    msgDiagramExists = 'Edit the Network Diagram';
    msgNoDiagramExists = 'Create a Network Diagram';
    buttonDiagramInventory = 'Diagram Inventory';
    buttonText: string = this.msgNoDiagramExists;
    hasDiagram: boolean = false;

    constructor(private router: Router,
       
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public configSvc: ConfigService,
        public authSvc: AuthenticationService,
        private location: Location
    ) { }
    tree: NavTreeNode[] = [];
    ngOnInit() {
        this.populateTree();
        this.assessSvc.hasDiagram().subscribe((resp: boolean) => {
            this.hasDiagram = resp;
            this.buttonText = this.hasDiagram ? this.msgDiagramExists : this.msgNoDiagramExists;
        });

        // When returning from Diagram, we get a brand new authSvc.
        // This refreshes the isLocal flag.
        if (this.authSvc.isLocal === undefined) {
            this.authSvc.checkLocalInstallStatus().subscribe((resp: boolean) => {
                this.authSvc.isLocal = resp;
            });
        }
    }

    populateTree() {
        this.navSvc.buildTree(this.navSvc.getMagic());
    }

    sendToDiagram() {
        const jwt = sessionStorage.getItem('userToken');
        const apiUrl = this.configSvc.apiUrl;
        let host = this.configSvc.apiUrl;
        if (host.endsWith('/api/')) {
            host = host.substr(0, host.length - 4);
        }

        window.location.href = host + 'diagram/src/main/webapp/index.html' +
            '?j=' + jwt +
            '&h=' + apiUrl +
            '&c=' + window.location.origin +
            '&l=' + this.authSvc.isLocal,
            sessionStorage.getItem('assessmentId');
    }
    sendToInventory() {
        this.router.navigateByUrl('/assessment/' + sessionStorage.getItem('assessmentId') + '/diagram/inventory');
    }
}
