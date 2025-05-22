////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { UserService } from '../../services/user.service';
import { Roles, UserRole } from '../../models/user.model';


@Component({
  selector: 'app-admin-settings',
  templateUrl: './admin-settings.component.html',
  host: { class: 'd-flex flex-column flex-11a w-100' },
  standalone: false
})

export class AdminSettingsComponent implements OnInit {

  users: UserRole[] = [];
  roles: Roles[] = [];

  constructor(
    private userSvg: UserService) {
  }

  ngOnInit() {
    this.getUsers();
    this.getAvailableRoles();
  }

  // Return available roles from database
  getAvailableRoles() {
    this.userSvg.getAvailableRoles().subscribe(data => {
      this.roles = data
    });
  }

  // Return users from database 
  getUsers() {
    this.userSvg.getUsers().subscribe(data => {
      this.users = data
    });
  }

  // Update user role 
  updateUserRole(user: UserRole) {
    this.userSvg.updateUserRole(user).subscribe(resp => { });
  }

  onRoleChange(user: UserRole) {
    this.updateUserRole(user);
  }

}
