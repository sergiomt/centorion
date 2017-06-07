echo Copying Clocial Classes
cp -rvu /vagrant/clocial/clocial-web/target/classes/* /vagrant/clocial/clocial-web/target/clocial-web-1.0/WEB-INF/classes
echo Copying Clocial Resources
cp -rvu /vagrant/clocial/clocial-web/src/resources/* /vagrant/clocial/clocial-web/target/clocial-web-1.0/WEB-INF/classes
echo Copying Clocial JSP Pages
cp -rvu /vagrant/clocial/clocial-web/src/main/webapp/* /vagrant/clocial/clocial-web/target/clocial-web-1.0/
echo Done!
