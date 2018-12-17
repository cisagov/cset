import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { SetDetail } from '../../models/set-builder.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-custom-set',
  templateUrl: './custom-set.component.html'
})
export class CustomSetComponent implements OnInit {

  setDetail: SetDetail = {};

  constructor(private builderSvc: SetBuilderService,
    private router: Router) { }

  ngOnInit() {
    const setName = sessionStorage.getItem('setName');
    this.builderSvc.getSetDetail(setName).subscribe((response) => {
      this.setDetail = response;
    });
  }

  update(e) {
    this.builderSvc.updateSetDetails(this.setDetail);
  }
}
