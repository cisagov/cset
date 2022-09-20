import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-landing-page-tabs',
  templateUrl: './landing-page-tabs.component.html',
  styleUrls: ['./landing-page-tabs.component.scss'],
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class LandingPageTabsComponent implements OnInit {

  currentTab: string;
  constructor(private route: ActivatedRoute, private router: Router) { }

  ngOnInit(): void {
    this.setTab('newAssessment');

    // setting the tab when we get a query parameter.
    this.route.queryParamMap.pipe(filter(params => params.has('tab'))).subscribe(params => {
      this.setTab(params.get('tab'));
      // clear the query parameters from the url.
      this.router.navigate([], { queryParams: {} });
    });
  }

  setTab(tab) {
    this.currentTab = tab;
  }

  checkActive(tab) {
    return this.currentTab === tab;
  }
}
