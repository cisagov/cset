import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../services/assessment.service';
import { Navigation2Service } from '../../services/navigation2.service';
import { NavigationService, NavTree } from '../../services/navigation.service';
import { AuthenticationService } from '../../services/authentication.service';
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
        public authSvc: AuthenticationService,
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

    launchDiagram() {
        console.log('launchDiagram');
        console.log(this.authSvc.userToken());
        const url = this.configSvc.apiUrl + "../diagram/src/main/webapp/index.html" + "?j=" + this.authSvc.userToken();
        window.open(url, "_blank");
    }
}
