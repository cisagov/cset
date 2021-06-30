import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraAnswerDistributionComponent } from './rra-answer-distribution.component';

describe('RraAnswerDistributionComponent', () => {
  let component: RraAnswerDistributionComponent;
  let fixture: ComponentFixture<RraAnswerDistributionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraAnswerDistributionComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraAnswerDistributionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
