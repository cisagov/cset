import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AliasAssessmentsComponent } from './alias-assessments.component';

describe('AliasAssessmentsComponent', () => {
  let component: AliasAssessmentsComponent;
  let fixture: ComponentFixture<AliasAssessmentsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AliasAssessmentsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AliasAssessmentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
