#ifndef TESSERACT_IGNITION_TESSERACT_IGNITION_VISUALIZATION_H
#define TESSERACT_IGNITION_TESSERACT_IGNITION_VISUALIZATION_H

#include <tesseract_visualization/visualization.h>
#include <tesseract_environment/core/environment.h>
#include <ignition/msgs/scene.pb.h>
#include <ignition/msgs/boolean.pb.h>
#include <ignition/transport/Node.hh>

namespace tesseract_ignition
{
/** @brief The Tesseract Ignition Vizualization class */
class TesseractIgnitionVisualization : public tesseract_visualization::Visualization
{
public:
  using Ptr = std::shared_ptr<TesseractIgnitionVisualization>;
  using ConstPtr = std::shared_ptr<const TesseractIgnitionVisualization>;

  TesseractIgnitionVisualization(tesseract_environment::Environment::ConstPtr env);

  /**
   * @brief Plot a trajectory
   * @param traj
   */
  void plotTrajectory(const std::vector<std::string>& joint_names, const Eigen::Ref<const tesseract_common::TrajArray>& traj) override;

  /**
   * @brief Plot the collision results data
   * @param link_names List of link names for which to plot data
   * @param dist_results The collision results data
   * @param safety_distance Vector of safety Distance corresponding to dist_results (Must be in the same order and
   * length).
   */
  void plotContactResults(const std::vector<std::string>& link_names,
                          const tesseract_collision::ContactResultVector& dist_results,
                          const Eigen::Ref<const Eigen::VectorXd>& safety_distances) override;

  /**
   * @brief Plot arrow defined by two points
   * @param pt1 Start position of the arrow
   * @param pt2 Final position of the arrow
   * @param rgba Color of the arrow
   * @param scale The size of the arrow (related to diameter)
   */
  void plotArrow(const Eigen::Ref<const Eigen::Vector3d>& pt1,
                 const Eigen::Ref<const Eigen::Vector3d>& pt2,
                 const Eigen::Ref<const Eigen::Vector4d>& rgba,
                 double scale) override;

  /**
   * @brief Plot axis
   * @param axis The axis
   * @param scale The size of the axis
   */
  void plotAxis(const Eigen::Isometry3d& axis, double scale) override;

  /**
   * @brief This is called at the start of the plotting for each iteration
   *        to clear previous iteration graphics if neccessary.
   */
  void clear() override;

  /** @brief Pause code and wait for enter key in terminal*/
  void waitForInput() override;

  void publishInitialScene();

private:
  tesseract_environment::Environment::ConstPtr env_; /**< The Env */
  ignition::transport::Node node_;                     /**< Ignition communication node. */
  ignition::transport::Node::Publisher scene_pub_;     /**< Scene publisher */
  ignition::transport::Node::Publisher pose_pub_;      /**< Pose publisher */
  ignition::transport::Node::Publisher deletion_pub_;  /**< Deletion publisher */

  bool initial_scene_published_ {false};

  bool OnSceneRequest(ignition::msgs::Scene& msg);
};

}  // namespace tesseract_ignition

#endif // TESSERACT_IGNITION_TESSERACT_IGNITION_VISUALIZATION_H
