import { Component, OnInit, ViewChild } from '@angular/core';
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

    msgDiagramExists = "Edit the network diagram";
    msgNoDiagramExists = "Create a network diagram";
    buttonText: string = this.msgNoDiagramExists;

    constructor(private router: Router,
        private navSvc: NavigationService,
        public assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        public configSvc: ConfigService
    ) { }
    tree: NavTree[] = [];
    ngOnInit() {
        this.populateTree();
        this.assessSvc.hasDiagram().subscribe((resp: boolean) => {
            this.buttonText = resp ? this.msgDiagramExists : this.msgNoDiagramExists;
          });
        this.assessSvc.currentTab = "diagram"
    }

    populateTree() {
        const magic = this.navSvc.getMagic();
        this.navSvc.setTree(this.tree, magic);
    }
}
