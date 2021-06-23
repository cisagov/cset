import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraAnswerCountsComponent } from './rra-answer-counts.component';

describe('RraAnswerCountsComponent', () => {
  let component: RraAnswerCountsComponent;
  let fixture: ComponentFixture<RraAnswerCountsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraAnswerCountsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraAnswerCountsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
