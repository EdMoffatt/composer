(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� t�Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��oj�n���k}k�^ݺ�>Y�Wn��!��S��i�xEiyx��G�(��� (�ė�9�y�M���Z��:�����v���C�>���i7���`���2��q��)��+�����[���D�X�X���_�,��w���叒$Zɿ\(����⊽u6\.��������>[ǩ��D�\�Ա��	�����t�eؙ.�􌣀�¡����ka�GsAQ����:�ԟG���럵{������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^�������"^��x��=��x�B��2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�o{�t������;�?����J�G�������:��x����=��R��R����nȒ�f����2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe���@�9��aRf�[7"��
��긝�0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�(����,�������7Me'����\�8�E�୍=w��u�!�Eݔk��������^A�wKs!?�� �|<4��Z*7V8���ϴ	B�D���MA� ����J��7�v}1ߍ$2%�F�4���5Vl�Z�:����6��Y�J.�\���+-5���Q��Δn�Z�lt�<���	����&E��@�4�~1�hp�~|n���ƒL�>�\G�/��:]dL�A����~�bd�T��M�6�7#Q�o�+��P��Hq���@^�N�2�'1�E]��YF�y���g|���v.��r���6��(^̺����Y�r,�Y��i6�uه�nó��wkf9�%��M�7��{��+�/$�G�O}�W�}��Jb�����_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽/S$y�@�� � �Pt%�ĳ#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t���[���^�湘[��A+B�����G�Х���hz.��Ti�\OT�Z�@ᶅ���i��iʙ������E�r>� ����Mf��rB�=<�!�|-�t��������L^��B>J$��O'��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`���?I�U�G)���,��������2P��U�_���?����9���?��P�	�%�Z�Iӕ�W
���*������):�I#������8E��CД�4�2��:F������8�^���w�����(��*����\��÷{�`?�hR��Ñ�z���:�%��"" �����2�^��Y��l�V0#&㆜4M��2��[��a=���j�K�9��n��vdA{0���m-��v���
��%H��,e{V�?��/��g��T��������?de��@��W��U���߻��g��T�_
>H���?$����J������ߛ9	�G(L���.@^����`���W�%��wkp��L̇0�н4��>�
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��BA�:ܠ�ɪc��,�=Ѻ�i[<2.g�cFґ����9��A�6h�p�4�	Cr��}El	`�8�v�vSt���MV&�����-�3�q�|�0�ٓI�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����CU�_>D����S�)���*����?�x��w�wv9��Z�)�D��������1%*�/�W�_������C�J=��(A���2p	�{�M:x������Юoh�a8�zn�<ΰJ",�8, �Ϣ4K��]e��~(C����!4�W�_� �Oe®ȯV+U���؜����=�i�m����?��)���W��}'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�X�����?�����j���A���y
�;�����rp��o__f.�?NЕ������A��˗����q���_>R�/m�X�8�!���R�;��`8�|�']����O��F�"�g1"`1Ǳm�el��P�Pp�%X�=,��B�]�� g	&�f�G����P��/_�����O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��K�A���T������CI��G!x����O��՗fU(e���%ȧ���U��P
^��j�<���ϝ���k�KX0�}C~v��x���?K�ߟ����q��O��r1�K�Zo�H_������~�9���9���A��=zе�î�{&N>��)�b,��W�Km;��~�ILW���	�<�-b�Zt3����������P�YOԉ5�����j�s�ފ���{�A3Q�t�r֓��ex�L>2�{Ġ��Ām���N��-���|�����E�ք~ހNYe�6�xN�/ݩ�۝�ؐ�����^��.uF$��m�,O7|���0�v�X���M�i����o�)��足��Y�9ˌ������mo9�� ����N�ʹ��\��ފ��>�[Z��>\d��BiH�?/�#��K������x��������������9����*�-Q��_�����$P�:���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��Q~(�b�n#�[�������<�Z�� 컮�O���� �B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i�v��@���qv��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x������#��K�A\��#4U�������'��T�J�g�����A������?+���Q��W�������F���S`.��1�~��\.�˽�����PU�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0�:�B������/$]������ �eJ���-sjư���S�m�m+[,�Fi�5yq��1��t�V�֕�FwGѽdMq=�o{;�cN��sh}�
��A~
ӻ�N���r���)�2�Q_��,6��y����bw�GI����h���������?=��@����J��O�������A��n���}�j5�F��Zm١��6�'~��P��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}�I�vU� ���n�]E��k��]�������8]g���/!���?�:�7����Z6�]����ޣv�vU�\W+��¯���'�}_�8�h��/����W�rj�_O���ڕw�m��D��1��/9���[���x/��t�7K;*f�k���*��
�3�i��W��m���VWD]�o�*�sӑ���A��~�r}��b��/��hv�oGپ�T�;?���Z��u�i�]�~�kgQ�ٗ;��AG��d�[����ͫ�Yރ(K��o`t�7��p����"{��[�2iA�ϟ�^ܻ����G���?�ٝ���nz�k����?��}���~��ǖ����5����N]��t>]�7�4�Z��d�qb�'p��p8]O6�ua�~�n��vo�>���D����8���}7A5������gd���0��<��^��6���7|�*��q$�C4dE��o��y�VGƷu���J�3B�+�Ʒ�r��
��$����N�t��Ϟ�u�P�O��ż-T���{\����6�u����r9<.��r�˘�b���u�K��tݺ�t�ֽoJ�=]�n�֞v��5!&��4�o4B�@�D?)����A	$D�`����ж�z��휝����&�t��y���������y��d:c�lr�rSn%d"v���D2A�")<]F;�Y#�L&���LG�a\��e혀��I��,/L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�J�ńq!v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�Rt�kq���3V3EL<�d�v[�t�ԵQ�w����|x�Y����P�����&3ّ鶐-$��[�'�%��*|��H�w�w�8g܄�e���_3�\We�ДF�#!2�R��8�.�F�j�5�w���Bi1^2f^�[��[7gyQc4E��)��F�E�E�e�6��Q�ti&Nm8=�����_�S�;��ɉ����4�b|�\]������iU��=�s�g�w�yN��S�9�uPK�!ˠ�Hҩ��#U��q���YG�S���=�Re�EXs�7#�ˈ�H���׌�����|t�D��8��U���.s�fGW���u�q�]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3o u��j����g��d&/G��O�����g�uT�h��*�7V�x�s.���=��k�n���4m&?�t눅��8/��f��8��ˈ	���91�{�*���v.����7��Z��|WW�%�Ѕ����÷9Z���������3w��T��WU�1�p�i�捣�����#`>��&�m�߭:����F��f��������w?�W��!PX;�qj��?���Z*q�m����<�j �S��ȶ�W���¶�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ���c�?/K�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}��N��M  