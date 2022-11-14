import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-logout',
  templateUrl: './logout.component.html'
})
export class LogoutComponent implements OnInit {

  constructor(
    private router: Router
  ) { 
    // remove user from session storage to log user out
    localStorage.clear();
    this.router.navigate(['/home/login'], { queryParamsHandling: "preserve" });
  }

  /**
   * 
   */
  ngOnInit(): void {
    
  }

}
