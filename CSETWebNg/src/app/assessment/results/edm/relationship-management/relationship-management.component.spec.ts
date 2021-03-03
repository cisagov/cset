import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RelationshipManagementComponent } from './relationship-management.component';

describe('RelationshipManagementComponent', () => {
  let component: RelationshipManagementComponent;
  let fixture: ComponentFixture<RelationshipManagementComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RelationshipManagementComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RelationshipManagementComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
