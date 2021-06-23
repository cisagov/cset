import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraLevelsComponent } from './rra-levels.component';

describe('RraLevelsComponent', () => {
  let component: RraLevelsComponent;
  let fixture: ComponentFixture<RraLevelsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraLevelsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraLevelsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
