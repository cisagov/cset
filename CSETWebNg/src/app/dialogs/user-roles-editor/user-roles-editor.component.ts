import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Comparer } from '../../helpers/comparer';
import { AuthenticationService } from '../../services/authentication.service';
import { LayoutService } from '../../services/layout.service';

@Component({
  selector: 'app-user-roles-editor',
  // imports: [],
  templateUrl: './user-roles-editor.component.html',
  styleUrl: './user-roles-editor.component.scss',
  standalone: false
})
export class UserRolesEditorComponent implements OnInit {

  userRoles: any = [];
  roles: any[] = [];
  comparer: Comparer = new Comparer();

  constructor(
    private dialog: MatDialogRef<UserRolesEditorComponent>,
    private authSvc: AuthenticationService,
    public layoutSvc: LayoutService,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { }

  ngOnInit() {
    this.authSvc.getUsersAndRoles().subscribe(
      (r: any) => {
        this.userRoles = r.userRoles;
        this.roles = r.roles;
      }
    );
  }



  /**
   *
   */
  close() {
    this.dialog.close();
  }

  /**
   * 
   */
  sortData(sort: Sort) {
    if (!sort.active || sort.direction === "") {
      return;
    }

    this.userRoles.sort((a, b) => {
      const isAsc = sort.direction === "asc";
      switch (sort.active) {
        case "lastName":
          return this.comparer.compare(a.lastName, b.lastName, isAsc);
        case "firstName":
          return this.comparer.compare(a.firstName, b.firstName, isAsc);
        case "email":
          return this.comparer.compare(a.primaryEmail, b.primaryEmail, isAsc);
        case "role":
          return this.comparer.compare(a.userRoles.roleId, b.userRoles.roleId, isAsc);
        default:
          return 0;
      }
    });
  }


  toggleRole(userInfo: any, role: any, index: number) {
    let userRole = userInfo.userRoles;

    userRole = {
      role: role,
      roleId: role.roleId, 
      user: userRole?.user ?? null,
      userId: userInfo.userId,
      userRoleId: userRole?.userRoleId ?? 0
    };

    this.userRoles[index].userRoles = userRole;
    this.updateRoles(userRole);
  }

  updateRoles(updatedUserRole: any) {
    this.authSvc.setUsersAndRoles(updatedUserRole).subscribe();
  }

}
