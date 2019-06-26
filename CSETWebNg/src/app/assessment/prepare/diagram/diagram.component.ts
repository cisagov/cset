import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { Navigation2Service } from '../../../services/navigation2.service';

@Component({
    selector: 'app-diagram',
    templateUrl: './diagram.component.html',
    styleUrls: ['./diagram.component.scss']
})
export class DiagramComponent implements OnInit {
  

    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
    ) { }

    ngOnInit() {
    }
}
