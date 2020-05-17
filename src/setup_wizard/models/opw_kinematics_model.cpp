#include <tesseract_ignition/setup_wizard/models/opw_kinematics_model.h>
#include <Eigen/Geometry>
#include <QVector3D>

namespace tesseract_ignition
{

OPWKinematicsModel::OPWKinematicsModel(QObject *parent)
  : QStandardItemModel(parent)
{
}

OPWKinematicsModel::OPWKinematicsModel(const OPWKinematicsModel &other)
  : QStandardItemModel(other.d_ptr->parent)
{
  this->thor_ = other.thor_;
}

OPWKinematicsModel &OPWKinematicsModel::operator=(const OPWKinematicsModel &other)
{
  this->thor_ = other.thor_;
  return *this;
}

QHash<int, QByteArray> OPWKinematicsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[GroupNameRole] = "group_name";
    roles[KinematicParametersRole] = "parameters";
    roles[JointOffsetRole] = "offsets";
    roles[JointCorrectionRole] = "sign_corrections";
    return roles;
}

void OPWKinematicsModel::setTesseract(tesseract::Tesseract::Ptr thor)
{
  this->clear();
  thor_ = thor;

  for (const auto& group : thor_->getSRDFModelConst()->getGroupOPWKinematics())
    addItem(QString::fromStdString(group.first), group.second);
}

void OPWKinematicsModel::add(const QString& group_name,
                             double a1, double a2, double b,
                             double c1, double c2, double c3, double c4,
                             double o1, double o2, double o3, double o4, double o5, double o6,
                             int sc1, int sc2, int sc3, int sc4, int sc5, int sc6)
{
  auto& group_opw_kinematics = thor_->getSRDFModel()->getGroupOPWKinematics();
  auto group = group_opw_kinematics.find(group_name.toStdString());
  bool add = false;

  if (group == group_opw_kinematics.end())
  {
    add = true;
    group_opw_kinematics[group_name.toStdString()] = tesseract_scene_graph::SRDFModel::OPWKinematicParameters();
    group = group_opw_kinematics.find(group_name.toStdString());
  }

  group->second.a1 = a1;
  group->second.a2 = a2;
  group->second.b = b;
  group->second.c1 = c1;
  group->second.c2 = c2;
  group->second.c3 = c3;
  group->second.c4 = c4;
  group->second.offsets[0] = o1;
  group->second.offsets[1] = o2;
  group->second.offsets[2] = o3;
  group->second.offsets[3] = o4;
  group->second.offsets[4] = o5;
  group->second.offsets[5] = o6;
  group->second.sign_corrections[0] = static_cast<signed char>(sc1);
  group->second.sign_corrections[1] = static_cast<signed char>(sc2);
  group->second.sign_corrections[2] = static_cast<signed char>(sc3);
  group->second.sign_corrections[3] = static_cast<signed char>(sc4);
  group->second.sign_corrections[4] = static_cast<signed char>(sc5);
  group->second.sign_corrections[5] = static_cast<signed char>(sc6);

  if (add)
    addItem(group_name, group->second);
  else // replace
    setTesseract(thor_);
}

bool OPWKinematicsModel::removeRows(int row, int count, const QModelIndex &parent)
{
  if (row >= 0)
  {
    QStandardItem *row_item = item(row);
    QString group_name = row_item->data(OPWKinematicsRoles::GroupNameRole).toString();
    auto& group_opw = thor_->getSRDFModel()->getGroupOPWKinematics();
    group_opw.erase(group_name.toStdString());
    return QStandardItemModel::removeRows(row, count, parent);
  }
  return false;
}

void OPWKinematicsModel::addItem(const QString& group_name, const tesseract_scene_graph::SRDFModel::OPWKinematicParameters& opw)
{
  QStandardItem *parent_item = this->invisibleRootItem();
  auto item = new QStandardItem();
  item->setData(group_name, OPWKinematicsRoles::GroupNameRole);

  QString param_string = QString("a1: %1, a2: %2, b: %3, c1: %4, c2: %5, c3: %6, c4: %7").arg(opw.a1).arg(opw.a2).arg(opw.b).arg(opw.c1).arg(opw.c2).arg(opw.c3).arg(opw.c4);
  item->setData(param_string, OPWKinematicsRoles::KinematicParametersRole);

  QString offsets_string = QString::number(opw.offsets[0]);
  QString sign_corrections_string = QString::number(opw.sign_corrections[0]);
  for (std::size_t i = 0; i < 6; ++i)
  {
    offsets_string += "," + QString::number(opw.offsets[i]);
    sign_corrections_string += "," + QString::number(opw.sign_corrections[i]);
  }

  item->setData(offsets_string, OPWKinematicsRoles::JointOffsetRole);
  item->setData(sign_corrections_string, OPWKinematicsRoles::JointCorrectionRole);
  parent_item->appendRow(item);
}

}
