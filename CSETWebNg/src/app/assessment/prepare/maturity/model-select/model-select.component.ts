import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material';
import { Navigation2Service } from '../../../../services/navigation2.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-model-select',
  templateUrl: './model-select.component.html'
})
export class ModelSelectComponent implements OnInit {

  constructor(
    private router: Router,
    private assessSvc: AssessmentService,
    public navSvc2: Navigation2Service,
    public dialog: MatDialog
  ) { }

  ngOnInit() {
  }

}
