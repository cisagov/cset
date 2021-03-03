import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RelationshipFormationComponent } from './relationship-formation.component';

describe('RelationshipFormationComponent', () => {
  let component: RelationshipFormationComponent;
  let fixture: ComponentFixture<RelationshipFormationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RelationshipFormationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RelationshipFormationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
