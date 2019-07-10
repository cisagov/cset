import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../services/assessment.service';
import { Navigation2Service } from '../../services/navigation2.service';
import { NavigationService, NavTree } from '../../services/navigation.service';
import { ConfigService } from '../../services/config.service';

@Component({
    selector: 'app-diagram',
    templateUrl: './diagram.component.html'
})
export class DiagramComponent implements OnInit {

    constructor(private router: Router,
        private navSvc: NavigationService,
        public assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        public configSvc: ConfigService
    ) { }
    tree: NavTree[] = [];
    ngOnInit() {
        this.populateTree();
    }

    populateTree() {
        const magic = this.navSvc.getMagic();
        this.navSvc.setTree(this.tree, magic);
    }

    sendToDiagram() {
        const jwt = sessionStorage.getItem("userToken");
        const apiUrl = this.configSvc.apiUrl;
        let host = this.configSvc.apiUrl;
        if (host.endsWith('/api/')) {
            host = host.substr(0, host.length - 4);
        }

        window.open(host + "diagram/src/main/webapp/index.html" +
            "?j=" + jwt +
            "&h=" + apiUrl, "_blank");
    }
}
