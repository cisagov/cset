import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';
import { NavigationService, NavTree } from '../../../services/navigation.service';
import { ConfigService } from '../../../services/config.service';
import { Location } from '@angular/common';
import { AuthenticationService } from '../../../services/authentication.service';

@Component({
    selector: 'app-info',
    templateUrl: './diagram-info.component.html'
})
export class DiagramInfoComponent implements OnInit {

    msgDiagramExists = 'Edit the network diagram';
    msgNoDiagramExists = 'Create a network diagram';
    buttonDiagramInventory = 'Diagram Inventory';
    buttonText: string = this.msgNoDiagramExists;
    hasDiagram: boolean = false;

    constructor(private router: Router,
        private navSvc: NavigationService,
        public assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        public configSvc: ConfigService,
        public authSvc: AuthenticationService,
        private location: Location
    ) { }
    tree: NavTree[] = [];
    ngOnInit() {
        this.populateTree();
        this.assessSvc.hasDiagram().subscribe((resp: boolean) => {
            this.hasDiagram = resp;
            this.buttonText = this.hasDiagram ? this.msgDiagramExists : this.msgNoDiagramExists;
        });
    }

    populateTree() {
        const magic = this.navSvc.getMagic();
        this.navSvc.setTree(this.tree, magic);
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
