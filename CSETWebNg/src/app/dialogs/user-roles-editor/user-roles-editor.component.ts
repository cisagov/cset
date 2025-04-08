import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Comparer } from '../../helpers/comparer';
import { AuthenticationService } from '../../services/authentication.service';

@Component({
  selector: 'app-user-roles-editor',
  // imports: [],
  templateUrl: './user-roles-editor.component.html',
  styleUrl: './user-roles-editor.component.scss',
  standalone: false
})
export class UserRolesEditorComponent implements OnInit {

  userRoles: any = [];
  roles: any = [];
  comparer: Comparer = new Comparer();

  constructor(
    private dialog: MatDialogRef<UserRolesEditorComponent>,
    private authSvc: AuthenticationService,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { }

  ngOnInit() {
    this.authSvc.getUsersAndRoles().subscribe(
      (r: any) => {
        this.userRoles = r.userRoles;
        this.roles = r.roles;
        console.log(r)
      }
    );
  }



  /**
   *
   */
  cancel() {
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
          return this.comparer.compare(a.roleId, b.roleId, isAsc);
        default:
          return 0;
      }
    });
  }

}
