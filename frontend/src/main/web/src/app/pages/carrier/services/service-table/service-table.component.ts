import {Component, OnInit} from '@angular/core';
import {clone} from 'ramda';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {MessageService} from 'primeng/components/common/messageservice';

import {Service} from '../shared/model/service.model';
import {ServiceService} from '../shared/service/service.service';


@Component({
  selector: 'app-service-table',
  templateUrl: './service-table.component.html',
  styleUrls: ['./service-table.component.scss']
})
export class ServiceTableComponent implements OnInit {

  services: Service[] = [];

  currentServiceForUpdate: Service;
  form: FormGroup;
  isForUpdateAlertMessage = false;
  filterContent = '';
  page: number = 1;

  constructor(private serviceService: ServiceService,
    private messageService: MessageService) {
  }

  ngOnInit() {
    this.setFormInDefault();
    this.getApprovedServices();
  }

  setFormInDefault() {

    this.form = new FormGroup(
      {
        service_name: new FormControl('', [Validators.required, Validators.minLength(3), Validators.max(50)]),
        service_descr: new FormControl('', [Validators.required, Validators.minLength(3)])
      }
    );

  }

  getApprovedServices(){
    this.serviceService.getServiceByStatus('PUBLISHED')
        .subscribe(
                        (resp: Response) => {
                          /*if (resp.headers.get('New-Access-Token')) {
                            localStorage.removeItem('at');
                            localStorage.setItem('at', resp.headers.get('New-Access-Token'));
                          }*/
                          this.services = clone(resp);
                        },
                        error => console.log(error)
                      );
  }

  updateService(service: Service){
    this.isForUpdateAlertMessage = true;
    let createdMessage = '';
    if (service.service_status == 'ARCHIVED') {
      createdMessage = this.createMessage('success',
        'The service ' + service.service_name + ' was archieved',
        'You can find it in Archive'
      );
    } else {
      createdMessage = this.createMessage('success',
        'The service ' + service.service_name + ' was edited',
        'It was sent for approvement'
      );
    }
    this.serviceService.updateService(service)
                      .subscribe(
                        (resp: Response) => {
                          /*if (resp.headers.get('New-Access-Token')) {
                            localStorage.removeItem('at');
                            localStorage.setItem('at', resp.headers.get('New-Access-Token'));
                          }*/
                          this.showMessage(createdMessage);
                          this.getApprovedServices();
                          this.isForUpdateAlertMessage = false;
                        },
                        error => console.log(error)
                      );
  }

  editService(service: Service){
    this.currentServiceForUpdate = service;

    this.form.patchValue({
                          service_name: this.currentServiceForUpdate.service_name,
                          service_descr: this.currentServiceForUpdate.service_descr
                         });
  }

  changeService(service: Service){
    service['service_name'] = this.form.get('service_name').value;
    service['service_descr'] = this.form.get('service_descr').value;
    service['service_status'] = 'OPEN';
    this.updateService(service);
  }

  closeUpdateForm(){
    this.currentServiceForUpdate = null;
    this.isForUpdateAlertMessage = false;
  }

  showMessage(msgObj: any) {
    this.messageService.add(msgObj);
  }

  createMessage(severity: string, summary: string, detail: string): any {
    return {
      severity: severity,
      summary: summary,
      detail: detail
    };
  }

  onChangePage(event: number) {
    this.page = event;
  }
}
