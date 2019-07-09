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

    sendToDiagram(){
        var jwt = sessionStorage.getItem("userToken");
        var assessmentId = sessionStorage.getItem("assessmentId");
        var apiUrl = this.configSvc.apiUrl;

        window.open("http://localhost:46000/diagram/src/main/webapp/index.html?j="+jwt+"&a=" +assessmentId+"&h="+apiUrl,"_blank");
    }
}
