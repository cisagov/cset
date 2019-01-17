import { Component, OnInit } from '@angular/core';
import { Requirement } from '../../models/set-builder.model';
import { SetBuilderService } from '../../services/set-builder.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-requirement-detail',
  templateUrl: './requirement-detail.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class RequirementDetailComponent implements OnInit {

  r: Requirement;


  constructor(private setBuilderSvc: SetBuilderService,
    private route: ActivatedRoute) { }

  ngOnInit() {
    this.r = this.setBuilderSvc.activeRequirement;

    // if the service doesn't know it, try to get it from the URI
    if (!this.r) {
      this.setBuilderSvc.getRequirement(this.route.snapshot.params['id']).subscribe(result => {
        this.r = result;
        this.setBuilderSvc.activeRequirement = this.r;
      });
    }
  }

  formatLinebreaks(text: string) {
    return this.setBuilderSvc.formatLinebreaks(text);
  }

  hasSAL() {

  }

  toggleSAL() {

  }

  missingSAL() {

  }
}
