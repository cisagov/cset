import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GlobalConfigurationComponent } from './global-configuration.component';

describe('GlobalConfigurationComponent', () => {
  let component: GlobalConfigurationComponent;
  let fixture: ComponentFixture<GlobalConfigurationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ GlobalConfigurationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(GlobalConfigurationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
