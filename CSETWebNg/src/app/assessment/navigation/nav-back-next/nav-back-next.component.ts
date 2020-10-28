import { Component, Input, OnInit } from '@angular/core';
import { NavigationService } from '../../../services/navigation.service';

@Component({
  selector: 'app-nav-back-next',
  templateUrl: './nav-back-next.component.html'
})
export class NavBackNextComponent implements OnInit {

  @Input() page: string;

  @Input() hide: string;

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
  }

}
