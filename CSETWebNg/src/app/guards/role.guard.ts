import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router, CanActivate } from '@angular/router';
import { AuthenticationService } from '../services/authentication.service';
import { RoleType } from '../models/enums/role.model';

@Injectable({
    providedIn: 'root'
  })
  export class RoleGuard implements CanActivate {
    constructor(
      private authService: AuthenticationService,
      private router: Router
    ) {}
  
    canActivate(
      route: ActivatedRouteSnapshot
    ): boolean {
      const requiredRoles = route.data['roles'] as RoleType[];
  
      if (this.authService.hasRole(requiredRoles)) {
        return true;
      }
      this.router.navigate(['/home/login'], { queryParamsHandling: "preserve" });
      //this.router.navigate(['/unauthorized']);
      return false;
    }
  }