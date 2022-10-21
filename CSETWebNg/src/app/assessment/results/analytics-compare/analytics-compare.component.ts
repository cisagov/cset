import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
  selector: 'app-analytics-compare',
  templateUrl: './analytics-compare.component.html'
})
export class AnalyticsCompareComponent implements OnInit {

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
  }

}
